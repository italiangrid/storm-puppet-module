# @!puppet.type.param
# @summary StoRM WebDAV puppet module
#
# @example Basic usage
#
#    class { 'storm::webdav':
#      storage_areas => [
#        {
#          # minimal configuration
#          name                       => 'test.vo',
#          root_path                  => '/storage/test.vo',
#        },
#      ],
#    }
#
# @param ensure_empty_storage_area_dir
#   Clean storage area's configuration directory from old .properties files before adding the new ones. Default value: false.
#
# @param storage_areas
#   List of storage area's configuration. Default value: empty list.
#
# @param hostnames
#   Sets STORM_WEBDAV_HOSTNAME_(N) environment variables.
#
# @param http_port
#   Sets STORM_WEBDAV_HTTP_PORT environment variable.
#
# @param https_port
#   Sets STORM_WEBDAV_HTTPS_PORT environment variable.
#
# @param trust_anchors_refresh_interval
#   Sets STORM_WEBDAV_TRUST_ANCHORS_REFRESH_INTERVAL environment variable.
#
# @param max_concurrent_connections
#   Sets STORM_WEBDAV_MAX_CONNECTIONS environment variable.
#
# @param max_queue_size
#   Sets STORM_WEBDAV_MAX_QUEUE_SIZE environment variable.
#
# @param connector_max_idle_time
#   Sets STORM_WEBDAV_CONNECTOR_MAX_IDLE_TIME environment variable.
#
# @param vo_map_files_enable
#   Sets STORM_WEBDAV_VO_MAP_FILES_ENABLE environment variable.
#
# @param vo_map_files_config_dir
#   Sets STORM_WEBDAV_VO_MAP_FILES_CONFIG_DIR environment variable.
#
# @param vo_map_files_refresh_interval
#   Sets STORM_WEBDAV_VO_MAP_FILES_REFRESH_INTERVAL environment variable.
#
# @param tpc_max_connections
#   Sets STORM_WEBDAV_TPC_MAX_CONNECTIONS environment variable.
#
# @param tpc_max_connections_per_route
#   Sets STORM_WEBDAV_TPC_MAX_CONNECTIONS_PER_ROUTE environment variable.
#
# @param tpc_verify_checksum
#   Sets STORM_WEBDAV_TPC_VERIFY_CHECKSUM environment variable.
#
# @param tpc_timeout_in_secs
#   Sets STORM_WEBDAV_TPC_TIMEOUT_IN_SECS environment variable.
#
# @param tpc_tls_protocol
#   Sets STORM_WEBDAV_TPC_TLS_PROTOCOL environment variable.
#
# @param tpc_report_delay_secs
#   Sets STORM_WEBDAV_TPC_REPORT_DELAY_SECS environment variable.
#
# @param tpc_enable_tls_client_auth
#   Sets STORM_WEBDAV_TPC_ENABLE_TLS_CLIENT_AUTH environment variable.
#
# @param tpc_progress_report_thread_pool_size
#   Sets STORM_WEBDAV_TPC_PROGRESS_REPORT_THREAD_POOL_SIZE environment variable.
#
# @param jvm_opts
#   Sets part of STORM_WEBDAV_JVM_OPTS environment variable.
#
# @param authz_server_enable
#   Sets STORM_WEBDAV_AUTHZ_SERVER_ENABLE environment variable.
#
# @param authz_server_issuer
#   Sets STORM_WEBDAV_AUTHZ_SERVER_ISSUER environment variable if authz_server_enable is true.
#
# @param authz_server_max_token_lifetime_sec
#   Sets STORM_WEBDAV_AUTHZ_SERVER_MAX_TOKEN_LIFETIME_SEC environment variable if authz_server_enable is true.
#
# @param authz_server_secret
#   Sets STORM_WEBDAV_AUTHZ_SERVER_SECRET environment variable if authz_server_enable is true.
#
# @param require_client_cert
#   Sets STORM_WEBDAV_REQUIRE_CLIENT_CERT environment variable.
#
# @param use_conscrypt
#   Sets STORM_WEBDAV_USE_CONSCRYPT environment variable.
#
# @param tpc_use_conscrypt
#   Sets STORM_WEBDAV_TPC_USE_CONSCRYPT environment variable.
#
# @param enable_http2
#   Sets STORM_WEBDAV_ENABLE_HTTP2 environment variable.
#
# @param storm_limit_nofile
#   Sets LimitNOFILE value.
#
class storm::webdav (

  Boolean $ensure_empty_storage_area_dir,
  Array[Storm::Webdav::StorageArea] $storage_areas,

  Integer $http_port,
  Integer $https_port,
  Integer $trust_anchors_refresh_interval,
  Integer $max_concurrent_connections,
  Integer $max_queue_size,
  Integer $connector_max_idle_time,
  Boolean $vo_map_files_enable,
  String $vo_map_files_config_dir,
  Integer $vo_map_files_refresh_interval,
  Integer $tpc_max_connections,
  Integer $tpc_max_connections_per_route,
  Boolean $tpc_verify_checksum,
  Integer $tpc_timeout_in_secs,
  String $tpc_tls_protocol,
  Integer $tpc_report_delay_secs,
  Boolean $tpc_enable_tls_client_auth,
  Integer $tpc_progress_report_thread_pool_size,
  String $jvm_opts,
  Boolean $authz_server_enable,
  String $authz_server_issuer,
  Integer $authz_server_max_token_lifetime_sec,
  String $authz_server_secret,
  Boolean $require_client_cert,
  Boolean $use_conscrypt,
  Boolean $tpc_use_conscrypt,
  Boolean $enable_http2,

  Integer $storm_limit_nofile,

  Array[String] $hostnames = [ $::fqdn ],
) {

  contain storm::webdav::install
  contain storm::webdav::config
  contain storm::webdav::service

  Class['storm::webdav::install']
  -> Class['storm::webdav::config']
  -> Class['storm::webdav::service']
}
