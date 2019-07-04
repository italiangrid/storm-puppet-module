# Class: storm::webdav::params
# ===========================
#
class storm::webdav::params (
) inherits storm::params {

  $user_name = $storm::params::user_name
  $storage_areas = hiera('storm::webdav::params::storage_areas',[])

  $config_dir = hiera('storm::webdav::params::config_dir','/etc/storm/webdav')
  $hostcert_dir = hiera('storm::webdav::params::hostcert_dir','/etc/grid-security/storm-webdav')
  $oauth_issuers = hiera('storm::webdav::params::oauth_issuers',[])
  $hostnames = hiera('storm::webdav::params::hostnames',[])

  $http_port = hiera('storm::webdav::params::http_port',8085)
  $https_port = hiera('storm::webdav::params::https_port',8443)

  $trust_anchors_dir = hiera('storm::webdav::params::trust_anchors_dir','/etc/grid-security/certificates')
  $trust_anchors_refresh_interval = hiera('storm::webdav::params::trust_anchors_refresh_interval',86400)

  $max_concurrent_connections = hiera('storm::webdav::params::max_concurrent_connections',300)
  $max_queue_size = hiera('storm::webdav::params::max_queue_size',900)
  $connector_max_idle_time = hiera('storm::webdav::params::connector_max_idle_time',30000)

  $vo_map_files_enable = hiera('storm::webdav::params::vo_map_files_enable',false)
  $vo_map_files_config_dir = hiera('storm::webdav::params::vo_map_files_config_dir','/etc/storm/webdav/vo-mapfiles.d')
  $vo_map_files_refresh_interval = hiera('storm::webdav::params::vo_map_files_refresh_interval',21600)

  $tpc_max_connections = hiera('storm::webdav::params::tpc_max_connections',50)
  $tpc_verify_checksum = hiera('storm::webdav::params::tpc_verify_checksum',false)

  $log = hiera('storm::webdav::params::log','/var/log/storm/webdav/storm-webdav-server.log')
  $log_configuration = hiera('storm::webdav::params::log_configuration','/etc/storm/webdav/logback.xml')
  $access_log_configuration = hiera('storm::webdav::params::access_log_configuration','/etc/storm/webdav/logback-access.xml')

  $jvm_opts = hiera('storm::webdav::params::jvm_opts','-Xms256m -Xmx512m -Djava.io.tmpdir=/var/lib/storm-webdav/work')

  $authz_server_enable = hiera('storm::webdav::params::authz_server_enable',false)
  $authz_server_issuer = hiera('storm::webdav::params::authz_server_issuer','https://storm.example:8443')
  $authz_server_max_token_lifetime_sec = hiera('storm::webdav::params::authz_server_max_token_lifetime_sec',43200)
  $authz_server_secret = hiera('storm::webdav::params::authz_server_secret','areasonablesecretlongerthan256bits')
  $require_client_cert = hiera('storm::webdav::params::require_client_cert',false)

}
