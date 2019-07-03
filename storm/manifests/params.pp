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

  $components = []

  $webdav_config_dir = '/etc/storm/webdav'
  $webdav_hostcert_dir = '/etc/grid-security/storm-webdav'
  $webdav_oauth_issuers = []
  $webdav_hostnames = []

  $webdav_http_port = 8085
  $webdav_https_port = 8443

  $webdav_max_concurrent_connections = 300
  $webdav_max_queue_size = 900

  $webdav_vo_map_files_enable = false
  $webdav_vo_map_files_config_dir = '/etc/storm/webdav/vo-mapfiles.d'

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
