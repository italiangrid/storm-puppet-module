# @summary StoRM WebDAV params class
#
class storm::webdav::params (
) inherits storm::params {

  $application_file = lookup('storm::webdav::application_file', String, undef, '')
  $storage_areas_directory = lookup('storm::webdav::storage_areas_directory', String, undef, '')

  $storage_areas = lookup('storm::webdav::storage_areas', Array[Storm::Webdav::StorageArea], undef, [])

  $oauth_issuers = lookup('storm::webdav::oauth_issuers', Array[Storm::Webdav::OAuthIssuer], undef, [])
  $hostnames = lookup('storm::webdav::hostnames', Array[String], undef, [])

  $http_port = lookup('storm::webdav::http_port', Integer, undef, 8085)
  $https_port = lookup('storm::webdav::https_port', Integer, undef, 8443)

  $trust_anchors_dir = lookup('storm::webdav::trust_anchors_dir', String, undef, '/etc/grid-security/certificates')
  $trust_anchors_refresh_interval = lookup('storm::webdav::trust_anchors_refresh_interval', Integer, undef, 86400)

  $max_concurrent_connections = lookup('storm::webdav::max_concurrent_connections', Integer, undef, 300)
  $max_queue_size = lookup('storm::webdav::max_queue_size', Integer, undef, 900)
  $connector_max_idle_time = lookup('storm::webdav::connector_max_idle_time', Integer, undef, 30000)

  $vo_map_files_enable = lookup('storm::webdav::vo_map_files_enable', Boolean, undef, false)
  $vo_map_files_config_dir = lookup('storm::webdav::vo_map_files_config_dir', String, undef, '/etc/storm/webdav/vo-mapfiles.d')
  $vo_map_files_refresh_interval = lookup('storm::webdav::vo_map_files_refresh_interval', Integer, undef, 21600)

  $tpc_max_connections = lookup('storm::webdav::tpc_max_connections', Integer, undef, 50)
  $tpc_verify_checksum = lookup('storm::webdav::tpc_verify_checksum', Boolean, undef, false)

  $jvm_opts = lookup('storm::webdav::jvm_opts', String, undef, '-Xms256m -Xmx512m')

  $authz_server_enable = lookup('storm::webdav::authz_server_enable', Boolean, undef, false)
  $authz_server_issuer = lookup('storm::webdav::authz_server_issuer', String, undef, 'https://storm.example:8443')
  $authz_server_max_token_lifetime_sec = lookup('storm::webdav::authz_server_max_token_lifetime_sec', Integer, undef, 43200)
  $authz_server_secret = lookup('storm::webdav::authz_server_secret', String, undef, 'areasonablesecretlongerthan256bits')
  $require_client_cert = lookup('storm::webdav::require_client_cert', Boolean, undef, false)

  $use_conscrypt = lookup('storm::webdav::use_conscrypt', Boolean, undef, false)
  $tpc_use_conscrypt = lookup('storm::webdav::tpc_use_conscrypt', Boolean, undef, false)
  $enable_http2 = lookup('storm::webdav::enable_http2', Boolean, undef, false)

  $debug = lookup('storm::webdav::debug', Boolean, undef, false)
  $debug_port = lookup('storm::webdav::debug_port', Integer, undef, 1044)
  $debug_suspend = lookup('storm::webdav::debug_suspend', Boolean, undef, false)

  $storm_limit_nofile = lookup('storm::webdav::storm_limit_nofile', Integer, undef, 65535)
}
