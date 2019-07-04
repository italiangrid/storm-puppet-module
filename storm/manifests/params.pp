# Class: storm::params
# ===========================
#
# storm class default parameters
#
class storm::params {

  $user_name = 'storm'
  $storage_root_dir = '/storage'
  $storage_areas = []
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
