# Class: storm::webdav
# ===========================
#
class storm::webdav (

  String $user_name = $storm::webdav::params::user_name,
  Array[Storm::Webdav::StorageArea] $storage_areas = $storm::webdav::params::storage_areas,

  String $config_dir = $storm::webdav::params::config_dir,
  String $hostcert_dir = $storm::webdav::params::hostcert_dir,
  Array[Storm::Webdav::OAuthIssuer] $oauth_issuers = $storm::webdav::params::oauth_issuers,
  Array[String] $hostnames = $storm::webdav::params::hostnames,

  Integer $http_port = $storm::webdav::params::http_port,
  Integer $https_port = $storm::webdav::params::https_port,

  String $trust_anchors_dir = $storm::webdav::params::trust_anchors_dir,
  Integer $trust_anchors_refresh_interval = $storm::webdav::params::trust_anchors_refresh_interval,

  Integer $max_concurrent_connections = $storm::webdav::params::max_concurrent_connections,
  Integer $max_queue_size = $storm::webdav::params::max_queue_size,
  Integer $connector_max_idle_time = $storm::webdav::params::connector_max_idle_time,

  Boolean $vo_map_files_enable = $storm::webdav::params::vo_map_files_enable,
  String $vo_map_files_config_dir = $storm::webdav::params::vo_map_files_config_dir,
  Integer $vo_map_files_refresh_interval = $storm::webdav::params::vo_map_files_refresh_interval,

  Integer $tpc_max_connections = $storm::webdav::params::tpc_max_connections,
  Boolean $tpc_verify_checksum = $storm::webdav::params::tpc_verify_checksum,

  String $log = $storm::webdav::params::log,
  String $log_configuration = $storm::webdav::params::log_configuration,
  String $access_log_configuration = $storm::webdav::params::access_log_configuration,

  String $jvm_opts = $storm::webdav::params::jvm_opts,

  Boolean $authz_server_enable = $storm::webdav::params::authz_server_enable,
  String $authz_server_issuer = $storm::webdav::params::authz_server_issuer,
  Integer $authz_server_max_token_lifetime_sec = $storm::webdav::params::authz_server_max_token_lifetime_sec,
  String $authz_server_secret = $storm::webdav::params::authz_server_secret,
  Boolean $require_client_cert = $storm::webdav::params::require_client_cert,

  Boolean $debug = $storm::webdav::params::debug,
  Integer $debug_port = $storm::webdav::params::debug_port,
  Boolean $debug_suspend = $storm::webdav::params::debug_suspend,

) inherits storm::webdav::params {

  contain storm::webdav::install
  contain storm::webdav::config
  contain storm::webdav::service

  Class['storm::webdav::install']
  -> Class['storm::webdav::config']
  -> Class['storm::webdav::service']
}
