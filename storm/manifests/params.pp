# Class: storm::params
# ===========================
#
# storm class default parameters
#
class storm::params {

  $user_name = 'storm'
  $storage_root_directory = '/storage'
  $storage_area = []
  $config_dirpath = '/etc/storm'

  $components = []

  $webdav_config_dirpath = '/etc/storm/webdav'
  $webdav_hostcert_dirpath = '/etc/grid-security/storm-webdav'

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
