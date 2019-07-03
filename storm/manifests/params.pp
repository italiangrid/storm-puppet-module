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

  $webdav_trust_anchors_dir = '/etc/grid-security/certificates'
  $webdav_trust_anchors_refresh_interval = 86400

  $webdav_max_concurrent_connections = 300
  $webdav_max_queue_size = 900
  $webdav_connector_max_idle_time = 30000

  $webdav_vo_map_files_enable = false
  $webdav_vo_map_files_config_dir = '/etc/storm/webdav/vo-mapfiles.d'
  $webdav_vo_map_files_refresh_interval = 21600

  $webdav_log = '/var/log/storm/webdav/storm-webdav-server.log'
  $webdav_log_configuration = '/etc/storm/webdav/logback.xml'
  $webdav_access_log_configuration = '/etc/storm/webdav/logback-access.xml'

  $webdav_tpc_max_connections = 50
  $webdav_tpc_verify_checksum = false

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
