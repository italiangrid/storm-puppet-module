# @summary Install MariaDB server and client, create empty databases 'storm_db' and 'storm_be_ISAM',
#     add storm user and all the necessary grants.
#
# @example Basic usage:
#     include storm::db
#
# @param fqdn_hostname
#     The Fully Qualified Domain Name of the host. Default value got from Puppet fact `fqdn`.
#
# @param root_password
#     MySQL root password. Default: 'storm'.
#
# @param storm_username
#     The username of the user used by storm services to query the databases. Default 'storm'.
#
# @param storm_password
#     The password of 'storm' username used by storm services to access the databases. Default: 'storm'.
#
# @param override_options
#     MySQL server override options. Read more about this at https://forge.puppet.com/puppetlabs/mysql/reference#override_options.
#
# @param limit_no_file
#     MariaDB setting for limitNoFile
#
class storm::db (

  String $fqdn_hostname = $::fqdn,
  String $root_password = 'storm',
  String $storm_username = 'storm',
  String $storm_password = 'storm',
  Data $override_options = {
    'mysqld' => {
      'bind-address'    => '0.0.0.0',
      'max_connections' => 2048,
    },
  },
  Integer $limit_no_file = 65535,

) {

  ## MySQL Client
  include 'mysql::client'

  $service_dir='/etc/systemd/system/mariadb.service.d'

  file { $service_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $service_file='/etc/systemd/system/mariadb.service.d/limits.conf'
  $service_template_file='storm/etc/systemd/system/mariadb.service.d/limits.conf.erb'

  file { $service_file:
    ensure  => present,
    content => template($service_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => [File[$service_dir]],
    notify  => Service['mysqld'],
  }

  ## MySQL Server
  class { 'mysql::server':
    root_password      => $root_password,
    manage_config_file => true,
    restart            => true,
    override_options   => $override_options,
    databases          => {
      'storm_db'      => {
        ensure  => 'present',
        charset => 'utf8',
        collate => 'utf8_general_ci',
      },
      'storm_be_ISAM' => {
        ensure  => 'present',
        charset => 'utf8',
        collate => 'utf8_general_ci',
      },
    },
    require            => [File[$service_file]],
  }

  $short_hostname = regsubst($fqdn_hostname, '^([^.]*).*$', '\1')
  notice("Computed short hostname for ${fqdn_hostname} => ${short_hostname}")

  mysql_user { "${storm_username}@${fqdn_hostname}":
    ensure        => 'present',
    password_hash => mysql::password($storm_password),
    require       => [Class['mysql::server']],
  }
  mysql_grant { "${storm_username}@${fqdn_hostname}/storm_db.*":
    user       => "${storm_username}@${fqdn_hostname}",
    table      => 'storm_db.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@${fqdn_hostname}"]],
  }
  mysql_grant { "${storm_username}@${fqdn_hostname}/storm_be_ISAM.*":
    user       => "${storm_username}@${fqdn_hostname}",
    table      => 'storm_be_ISAM.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@${fqdn_hostname}"]],
  }

  mysql_user { "${storm_username}@${short_hostname}":
    ensure        => 'present',
    password_hash => mysql::password($storm_password),
    require       => [Class['mysql::server']],
  }
  mysql_grant { "${storm_username}@${short_hostname}/storm_db.*":
    user       => "${storm_username}@${short_hostname}",
    table      => 'storm_db.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@${short_hostname}"]],
  }
  mysql_grant { "${storm_username}@${short_hostname}/storm_be_ISAM.*":
    user       => "${storm_username}@${short_hostname}",
    table      => 'storm_be_ISAM.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@${short_hostname}"]],
  }

  mysql_user { "${storm_username}@%":
    ensure        => 'present',
    password_hash => mysql::password($storm_password),
    require       => [Class['mysql::server']],
  }
  mysql_grant { "${storm_username}@%/storm_db.*":
    user       => "${storm_username}@%",
    table      => 'storm_db.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@%"]],
  }
  mysql_grant { "${storm_username}@%/storm_be_ISAM.*":
    user       => "${storm_username}@%",
    table      => 'storm_be_ISAM.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@%"]],
  }

  mysql_user { "${storm_username}@localhost":
    ensure        => 'present',
    password_hash => mysql::password($storm_password),
    require       => [Class['mysql::server']],
  }
  mysql_grant { "${storm_username}@localhost/storm_db.*":
    user       => "${storm_username}@localhost",
    table      => 'storm_db.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@localhost"]],
  }
  mysql_grant { "${storm_username}@localhost/storm_be_ISAM.*":
    user       => "${storm_username}@localhost",
    table      => 'storm_be_ISAM.*',
    privileges => 'ALL',
    require    => [Mysql_user["${storm_username}@localhost"]],
  }


}
