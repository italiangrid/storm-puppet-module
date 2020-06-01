# @summary StoRM Database class
#
class storm::db (

) {

  $basearch = 'x86_64'
  $el = $::operatingsystemmajrelease

  yumrepo { 'repo.mysql.com':
    ensure   => present,
    descr    => 'repo.mysql.com',
    baseurl  => "http://repo.mysql.com/yum/mysql-5.6-community/el/${el}/${basearch}/",
    enabled  => 1,
    gpgcheck => true,
    gpgkey   => 'http://repo.mysql.com/RPM-GPG-KEY-mysql',
  }

  class { 'mysql::client':
    package_name => 'mysql-community-client',
    require      => Yumrepo['repo.mysql.com'],
  }

  class { 'mysql::server':
    package_name       => 'mysql-community-server',
    root_password      => 'storm',
    manage_config_file => true,
    service_name       => 'mysqld',
    require            => Yumrepo['repo.mysql.com'],
    override_options   => {
      mysqld      => {
        'bind-address' => '127.0.0.1',
        'log-error'    => '/var/log/mysqld.log',
      },
      mysqld_safe => {
        'log-error' => '/var/log/mysqld.log',
      },
    },
  }

  file { '/tmp/storm_db.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_db.sql',
  }

  mysql::db { 'storm_db':
    user     => 'storm',
    password => 'bluemoon',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
    sql      => '/tmp/storm_db.sql',
    require  => File['/tmp/storm_db.sql']
  }

  file { '/tmp/storm_be_ISAM.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_be_ISAM.sql',
  }

  mysql::db { 'storm_be_ISAM':
    user     => 'storm',
    password => 'bluemoon',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
    sql      => '/tmp/storm_be_ISAM.sql',
    require  => File['/tmp/storm_be_ISAM.sql']
  }

}
