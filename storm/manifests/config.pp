# Class: storm::config
# ===========================
#
class storm::config {

  $user_name = $storm::user_name
  $storage_root_directory = $storm::storage_root_directory
  $config_dirpath = $storm::config_dirpath

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

  file { $config_dirpath:
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }
}
