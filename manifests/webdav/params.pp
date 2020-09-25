# @summary StoRM WebDAV params class
#
class storm::webdav::params (
) inherits storm::params {

  # application.yml file management
  $manage_application_file = lookup('storm::webdav::manage_application_file', Boolean, undef, false)
  # if manage_application_file is set to true, init application_file with a concrete resource file ...
  $application_file = lookup('storm::webdav::application_file', String, undef, '')
  # ... or init it through variables
  $oauth_issuers = lookup('storm::webdav::oauth_issuers', Array[Storm::Webdav::OAuthIssuer], undef, [])

  # storage areas management
  $manage_storage_areas = lookup('storm::webdav::manage_storage_areas', Boolean, undef, true)
  # if manage_storage_areas is set to true, init storage areas reading property files from a concrete resource directory ...
  $storage_areas_directory = lookup('storm::webdav::storage_areas_directory', String, undef, '')
  # ... or init them through variables
  $storage_areas = lookup('storm::webdav::storage_areas', Array[Storm::Webdav::StorageArea], undef, [])

  # SystemD override file '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf' variables:
  # Set STORM_WEBDAV_HOSTNAME_{n}
  $hostnames = lookup('storm::webdav::hostnames', Array[String], undef, [])
  # Set STORM_WEBDAV_HTTP_PORT
  $http_port = lookup('storm::webdav::http_port', Integer, undef, 8085)
  # Set STORM_WEBDAV_HTTPS_PORT
  $https_port = lookup('storm::webdav::https_port', Integer, undef, 8443)
  # Set STORM_WEBDAV_TRUST_ANCHORS_REFRESH_INTERVAL
  $trust_anchors_refresh_interval = lookup('storm::webdav::trust_anchors_refresh_interval', Integer, undef, 86400)
  # Set STORM_WEBDAV_MAX_CONNECTIONS
  $max_concurrent_connections = lookup('storm::webdav::max_concurrent_connections', Integer, undef, 300)
  # Set STORM_WEBDAV_MAX_QUEUE_SIZE
  $max_queue_size = lookup('storm::webdav::max_queue_size', Integer, undef, 900)
  # Set STORM_WEBDAV_CONNECTOR_MAX_IDLE_TIME
  $connector_max_idle_time = lookup('storm::webdav::connector_max_idle_time', Integer, undef, 30000)
  # Set STORM_WEBDAV_VO_MAP_FILES_ENABLE
  $vo_map_files_enable = lookup('storm::webdav::vo_map_files_enable', Boolean, undef, false)
  # Set STORM_WEBDAV_VO_MAP_FILES_CONFIG_DIR
  $vo_map_files_config_dir = lookup('storm::webdav::vo_map_files_config_dir', String, undef, '/etc/storm/webdav/vo-mapfiles.d')
  # Set STORM_WEBDAV_VO_MAP_FILES_REFRESH_INTERVAL
  $vo_map_files_refresh_interval = lookup('storm::webdav::vo_map_files_refresh_interval', Integer, undef, 21600)
  # Set STORM_WEBDAV_TPC_MAX_CONNECTIONS
  $tpc_max_connections = lookup('storm::webdav::tpc_max_connections', Integer, undef, 50)
  # Set STORM_WEBDAV_TPC_VERIFY_CHECKSUM
  $tpc_verify_checksum = lookup('storm::webdav::tpc_verify_checksum', Boolean, undef, false)
  # Set part of STORM_WEBDAV_JVM_OPTS
  $jvm_opts = lookup('storm::webdav::jvm_opts', String, undef, '-Xms256m -Xmx512m')
  # Set STORM_WEBDAV_AUTHZ_SERVER_ENABLE
  $authz_server_enable = lookup('storm::webdav::authz_server_enable', Boolean, undef, false)
  # Set STORM_WEBDAV_AUTHZ_SERVER_ISSUER
  $authz_server_issuer = lookup('storm::webdav::authz_server_issuer', String, undef, 'https://storm.example:8443')
  # Set STORM_WEBDAV_AUTHZ_SERVER_MAX_TOKEN_LIFETIME_SEC
  $authz_server_max_token_lifetime_sec = lookup('storm::webdav::authz_server_max_token_lifetime_sec', Integer, undef, 43200)
  # Set STORM_WEBDAV_AUTHZ_SERVER_SECRET
  $authz_server_secret = lookup('storm::webdav::authz_server_secret', String, undef, 'areasonablesecretlongerthan256bits')
  # Set STORM_WEBDAV_REQUIRE_CLIENT_CERT
  $require_client_cert = lookup('storm::webdav::require_client_cert', Boolean, undef, false)
  # Set STORM_WEBDAV_USE_CONSCRYPT
  $use_conscrypt = lookup('storm::webdav::use_conscrypt', Boolean, undef, false)
  # Set STORM_WEBDAV_TPC_USE_CONSCRYPT
  $tpc_use_conscrypt = lookup('storm::webdav::tpc_use_conscrypt', Boolean, undef, false)
  # Set STORM_WEBDAV_ENABLE_HTTP2
  $enable_http2 = lookup('storm::webdav::enable_http2', Boolean, undef, false)
  # Set part of STORM_WEBDAV_JVM_OPTS
  $debug = lookup('storm::webdav::debug', Boolean, undef, false)
  $debug_port = lookup('storm::webdav::debug_port', Integer, undef, 1044)
  $debug_suspend = lookup('storm::webdav::debug_suspend', Boolean, undef, false)

  # /etc/systemd/system/storm-webdav.service.d/filelimit.conf
  # Set LimitNOFILE
  $storm_limit_nofile = lookup('storm::webdav::storm_limit_nofile', Integer, undef, 65535)

  # Logging directory permissions
  $log_dir_mode = lookup('storm::webdav::log_dir_mode', String, undef, '0750')
}
