# Class: storm::config
# ===========================
#
class storm::config (

  $user_name = $storm::params::user_name,
  $storage_root_directory = $storm::params::storage_root_directory,

) inherits storm::params {

  user { $user_name:
    ensure => present,
  }

  file { $storage_root_directory:
    ensure  => directory,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0755',
    recurse => true,
  }
}
