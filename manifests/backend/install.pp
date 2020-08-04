# @summary StoRM Backend install class
#
class storm::backend::install (

) {

  ## MySQL
  $basearch = 'x86_64'
  $el = $::operatingsystemmajrelease

  ## MySQL Repo
  yumrepo { 'repo.mysql.com':
    ensure   => present,
    descr    => 'repo.mysql.com',
    baseurl  => "http://repo.mysql.com/yum/mysql-5.6-community/el/${el}/${basearch}/",
    enabled  => 1,
    gpgcheck => true,
    gpgkey   => 'http://repo.mysql.com/RPM-GPG-KEY-mysql',
  }

  ## MySQL Client
  class { 'mysql::client':
    package_name => 'mysql-community-client',
    require      => Yumrepo['repo.mysql.com'],
  }

  if $storm::backend::mysql_server_install {

    ## MySQL Server (optional)
    class { 'mysql::server':
      package_name       => 'mysql-community-server',
      root_password      => $storm::backend::mysql_server_root_password,
      manage_config_file => true,
      service_name       => 'mysqld',
      require            => Yumrepo['repo.mysql.com'],
      override_options   => $storm::backend::mysql_server_override_options,
    }
  }

  ## StoRM Backend
  package { 'storm-backend-mp':
    ensure  => installed,
    require => Yumrepo['repo.mysql.com'],
  }

  if $storm::backend::install_native_libs_gpfs {

    ## Native libs GPFS
    package { 'storm-native-libs-gpfs' :
      ensure  => installed,
      require => [Package['storm-backend-mp']],
    }

  } else {

    # fail in case native libs gfps are needed
    if $storm::backend::fs_type == 'gpfs' {
      fail("You have declared fs_type as 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.")
    } else {
      $storm::backend::storage_areas.each | $sa | {
        if $sa[fs_type] == 'gpfs' {
          fail("Storage area ${sa[name]} is 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.")
        }
      }
    }
  }

  ## StoRM Info Provider
  package { 'storm-dynamic-info-provider':
    ensure  => installed,
    require => [Package['storm-backend-mp']],
  }
}
