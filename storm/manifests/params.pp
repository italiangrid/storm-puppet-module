# Class: storm::params
# ===========================
#
# storm class default parameters
#
class storm::params {

  $user_name = 'storm'
  $user_uid = 1100
  $user_gid = 1100

  $storage_root_dir = '/storage'
  $config_dir = '/etc/storm'
  $log_dir = '/var/log/storm'

  case $::osfamily {

    'RedHat': {
      # Only RedHat family is supported.
    }

    # In any other case raise error:
    default: {
      fail("StoRM module not supported on ${::osfamily}/${::operatingsystem}.")
    }
  }
}
