# @summary StoRM DB install class
#
class storm::db::install (

  $root_password = $storm::db::root_password,
  $max_connections = $storm::db::max_connections,

) inherits storm::db {

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
    root_password      => $root_password,
    manage_config_file => true,
    service_name       => 'mysqld',
    require            => Yumrepo['repo.mysql.com'],
    override_options   => {
      mysqld      => {
        'bind-address'    => '127.0.0.1',
        'log-error'       => '/var/log/mysqld.log',
        'max_connections' => $max_connections,
      },
      mysqld_safe => {
        'log-error' => '/var/log/mysqld.log',
      },
    },
  }
}
