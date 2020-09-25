# @!puppet.type.param
# @summary StoRM WebDAV puppet module
#
# @example Basic usage
#
#    class { 'storm::webdav':
#      storage_areas => [
#        {
#          name                       => 'test.vo',
#          root_path                  => '/storage/test.vo',
#          access_points              => ['/test.vo'],
#          vos                        => ['test.vo', 'test.vo.2'],
#        },
#        {
#          name                       => 'test.vo.2',
#          root_path                  => '/storage/test.vo.2',
#          access_points              => ['/test.vo.2'],
#          vos                        => ['test.vo.2'],
#          authenticated_read_enabled => true,
#          anonymous_read_enabled     => true,
#          vo_map_enabled             => false,
#        },  
#      ],
#      manage_application_file => true,
#      oauth_issuers => [
#        {
#          name   => 'indigo-dc',
#          issuer => 'https://iam-test.indigo-datacloud.eu/',
#        },
#      ],
#      hostnames => ['webdav.example.org', 'storm-webdav.example.org'],
#    }
#
#    class { 'storm::webdav':
#      manage_application_file => true,
#      application_file        => '/root/storm/webdav/application.yml',
#      storage_areas_directory => '/root/storm/webdav/sa.d',
#      hostnames               => ['storm-webdav.example.org'],
#    }
#
# @param manage_application_file
#   Set to True if you want to manage application.yml configuration. Default: false (application.yml file configuration is ignored). 
#
# @param application_file
#   If defined, the application.yml file is copied from this path and oauth_issuers is ignored. Ignored if manage_application_file is false.
#
# @param manage_storage_areas
#   Set to True if you want to manage storage areas configuration. Default: true.
#
# @param storage_areas_directory
#   If defined, the properties files of the storage areas are copied and storage_areas parameter is ignored.
#   Ignored if manage_storage_areas is false.
#
# @param storage_areas
#   List of storage area's configuration. Ignored if storage_areas_directory is defined.
#   Ignored if manage_storage_areas is false.
#
# @param oauth_issuers
#   List of OAuth issuers stored into application.yml. Ignored if application_file is defined.
#
# @param hostnames
#   Sets STORM_WEBDAV_HOSTNAME_{n} environment variables.
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
# @param tpc_verify_checksum
#   Sets STORM_WEBDAV_TPC_VERIFY_CHECKSUM environment variable.
#
# @param jvm_opts
#   Sets part of STORM_WEBDAV_JVM_OPTS environment variable.
#
# @param authz_server_enable
#   Sets STORM_WEBDAV_AUTHZ_SERVER_ENABLE environment variable.
#
# @param authz_server_issuer
#   Sets STORM_WEBDAV_AUTHZ_SERVER_ISSUER environment variable.
#
# @param authz_server_max_token_lifetime_sec
#   Sets STORM_WEBDAV_AUTHZ_SERVER_MAX_TOKEN_LIFETIME_SEC environment variable.
#
# @param authz_server_secret
#   Sets STORM_WEBDAV_AUTHZ_SERVER_SECRET environment variable.
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
# @param debug
#   Sets part of STORM_WEBDAV_JVM_OPTS environment variable. It enables remote debug.
#
# @param debug_port
#   Sets part of STORM_WEBDAV_JVM_OPTS environment variable. It sets the remote debug port if remote debug is enabled.
#
# @param debug_suspend
#   Sets part of STORM_WEBDAV_JVM_OPTS environment variable. It sets debug suspend value in case remote debug is enabled.
#
# @param storm_limit_nofile
#   Sets LimitNOFILE value.
#
class storm::webdav (

  Boolean $manage_application_file = $storm::webdav::params::manage_application_file,
  String $application_file = $storm::webdav::params::application_file,
  Array[Storm::Webdav::OAuthIssuer] $oauth_issuers = $storm::webdav::params::oauth_issuers,

  Boolean $manage_storage_areas = $storm::webdav::params::manage_storage_areas,
  String $storage_areas_directory = $storm::webdav::params::storage_areas_directory,
  Array[Storm::Webdav::StorageArea] $storage_areas = $storm::webdav::params::storage_areas,

  Array[String] $hostnames = $storm::webdav::params::hostnames,
  Integer $http_port = $storm::webdav::params::http_port,
  Integer $https_port = $storm::webdav::params::https_port,
  Integer $trust_anchors_refresh_interval = $storm::webdav::params::trust_anchors_refresh_interval,
  Integer $max_concurrent_connections = $storm::webdav::params::max_concurrent_connections,
  Integer $max_queue_size = $storm::webdav::params::max_queue_size,
  Integer $connector_max_idle_time = $storm::webdav::params::connector_max_idle_time,
  Boolean $vo_map_files_enable = $storm::webdav::params::vo_map_files_enable,
  String $vo_map_files_config_dir = $storm::webdav::params::vo_map_files_config_dir,
  Integer $vo_map_files_refresh_interval = $storm::webdav::params::vo_map_files_refresh_interval,
  Integer $tpc_max_connections = $storm::webdav::params::tpc_max_connections,
  Boolean $tpc_verify_checksum = $storm::webdav::params::tpc_verify_checksum,
  String $jvm_opts = $storm::webdav::params::jvm_opts,
  Boolean $authz_server_enable = $storm::webdav::params::authz_server_enable,
  String $authz_server_issuer = $storm::webdav::params::authz_server_issuer,
  Integer $authz_server_max_token_lifetime_sec = $storm::webdav::params::authz_server_max_token_lifetime_sec,
  String $authz_server_secret = $storm::webdav::params::authz_server_secret,
  Boolean $require_client_cert = $storm::webdav::params::require_client_cert,
  Boolean $use_conscrypt = $storm::webdav::params::use_conscrypt,
  Boolean $tpc_use_conscrypt = $storm::webdav::params::tpc_use_conscrypt,
  Boolean $enable_http2 = $storm::webdav::params::enable_http2,
  Boolean $debug = $storm::webdav::params::debug,
  Integer $debug_port = $storm::webdav::params::debug_port,
  Boolean $debug_suspend = $storm::webdav::params::debug_suspend,

  Integer $storm_limit_nofile = $storm::webdav::params::storm_limit_nofile,

) inherits storm::webdav::params {

  contain storm::webdav::install
  contain storm::webdav::config
  contain storm::webdav::service

  Class['storm::webdav::install']
  -> Class['storm::webdav::config']
  -> Class['storm::webdav::service']
}
