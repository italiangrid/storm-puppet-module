# @!puppet.type.param
# @summary StoRM WebDAV puppet module
#
# Parameters
# ----------
# 
# The main StoRM WebDAV configuration parameters are:
#
# * `user_name`: the Unix user that runs storm-webdav service;
# * `storage_areas`: the list of Storm::Webdav::StorageArea elements (more info below);
# * `oauth_issuers`: the list of Storm::Webdav::OAuthIssuer elements that means the supported OAuth providers;
# * `hostnames`: the list of hostname and aliases supported for Third-Party-Copy;
# * `http_port` and `https_port`: the service ports;
#
# The Storm::Webdav::StorageArea type
# --------------------
#
# * `name`: The name of the storage area. Required.
# * `root_path`: The path of the storage area root directory. Required.
# * `access_points`: A list of logic path used to access storage area's root. Required.
# * `vos`: A list of one or more Virtual Organization names of the users allowed to read/write into the storage area. Required.
# * `orgs`: A list of one or more Organizations. Optional.
# * `authenticated_read_enabled`: A boolean value used to enable the read of the storage area content to authenticated users. Required.
# * `anonymous_read_enabled`:  A boolean value used to enable anonymous read access to storage area content. Required.
# * `vo_map_enabled`: A boolean value used to enable the use of the VO gridmap files. Required.
# * `vo_map_grants_write_access`: A boolean value used to grant write access to the VO users read from grifmap file. Optional,
#
# The Storm::Webdav::OAuthIssuer type
# --------------------
#
# * `name`: the organization name. Rerquired.
# * `issuer`: the issuer URL. Required.
#
# @example Example of usage
#    class { 'storm::webdav':
#      storage_areas => [
#        {
#          name                       => 'test.vo',
#          root_path                  => '/storage/test.vo',
#          access_points              => ['/test.vo'],
#          vos                        => ['test.vo', 'test.vo.2'],
#          authenticated_read_enabled => false,
#          anonymous_read_enabled     => false,
#          vo_map_enabled             => false,
#        },
#        {
#          name                       => 'test.vo.2',
#          root_path                  => '/storage/test.vo.2',
#          access_points              => ['/test.vo.2'],
#          vos                        => ['test.vo.2'],
#          authenticated_read_enabled => false,
#          anonymous_read_enabled     => false,
#          vo_map_enabled             => false,
#        },  
#      ],
#      oauth_issuers => [
#        {
#          name   => 'indigo-dc',
#          issuer => 'https://iam-test.indigo-datacloud.eu/',
#        },
#      ],
#      hostnames => ['localhost', 'alias.for.localhost'],
#    }
#
# @param storage_areas
#   List of storage area's configuration.
#
# @param oauth_issuers
#
# @param hostnames
#
# @param http_port
#
# @param https_port
#
# @param trust_anchors_refresh_interval
#
# @param max_concurrent_connections
#
# @param max_queue_size
#
# @param connector_max_idle_time
#
# @param vo_map_files_enable
#
# @param vo_map_files_config_dir
#
# @param vo_map_files_refresh_interval
#
# @param tpc_max_connections
#
# @param tpc_verify_checksum
#
# @param jvm_opts
#
# @param authz_server_enable
#
# @param authz_server_issuer
#
# @param authz_server_max_token_lifetime_sec
#
# @param authz_server_secret
#
# @param require_client_cert
#
# @param use_conscrypt
#
# @param tpc_use_conscrypt
#
# @param enable_http2
#
# @param debug
#
# @param debug_port
#
# @param debug_suspend
#
# @param storm_limit_nofile
#
class storm::webdav (

  Array[Storm::Webdav::StorageArea] $storage_areas = $storm::webdav::params::storage_areas,

  Array[Storm::Webdav::OAuthIssuer] $oauth_issuers = $storm::webdav::params::oauth_issuers,
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
