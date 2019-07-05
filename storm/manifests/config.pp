# Class: storm::config
# ===========================
#
class storm::config (

  $user_name = $storm::user_name,
  $user_uid = $storm::user_uid,
  $user_gid = $storm::user_gid,

  $storage_root_dir = $storm::storage_root_dir,
  $config_dir = $storm::config_dir,
  $log_dir = $storm::log_dir,

) {

  # check storm user
  storm::user { 'storm user':
    user_name => $user_name,
    user_uid  => $user_uid,
    user_gid  => $user_gid,
  }

  # check root path
  storm::storage_root_dir { 'check_storage_root_dir':
    path  => $storage_root_dir,
    owner => $user_name,
    group => $user_name,
  }

  file { $config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  file { $log_dir:
    ensure  => directory,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0755',
    recurse => true,
  }
}
