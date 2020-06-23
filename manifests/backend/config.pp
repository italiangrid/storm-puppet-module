# @summary StoRM Backend config class
#
class storm::backend::config (

  $hostname = $storm::backend::hostname,

  $info = $storm::backend::info,
  $database = $storm::backend::database,

  $storage_areas = $storm::backend::storage_areas,
  $gsiftp_pool_members = $storm::backend::gsiftp_pool_members,
  $gsiftp_pool_balance_strategy = $storm::backend::gsiftp_pool_balance_strategy,
  $webdav_pool_members = $storm::backend::webdav_pool_members,
  $srm_pool_members = $storm::backend::srm_pool_members,
  $rfio_hostname = $storm::backend::rfio_hostname,
  $rfio_port = $storm::backend::rfio_port,
  $xroot_hostname = $storm::backend::xroot_hostname,
  $xroot_port = $storm::backend::xroot_port,
  $srm_hostname = $storm::backend::frontend_public_host,
  $frontend_public_host = $storm::backend::frontend_public_host,
  $frontend_port = $storm::backend::frontend_port,

  $directory_automatic_creation = $storm::backend::directory_automatic_creation,
  $directory_writeperm = $storm::backend::directory_writeperm,

  $rest_services_port = $storm::backend::rest_services_port,
  $rest_services_max_threads = $storm::backend::rest_services_max_threads,
  $rest_services_max_queue_size = $storm::backend::rest_services_max_queue_size,

  $synchcall_xmlrpc_unsecure_server_port = $storm::backend::synchcall_xmlrpc_unsecure_server_port,
  $synchcall_xmlrpc_maxthread = $storm::backend::synchcall_xmlrpc_maxthread,
  $synchcall_xmlrpc_max_queue_size = $storm::backend::synchcall_xmlrpc_max_queue_size,
  $synchcall_xmlrpc_security_enabled = $storm::backend::synchcall_xmlrpc_security_enabled,
  $synchcall_xmlrpc_security_token = $storm::backend::synchcall_xmlrpc_security_token,
) {

  $namespace_file='/etc/storm/backend-server/namespace.xml'
  $namespace_template_file='storm/etc/storm/backend-server/namespace.xml.erb'

  file { $namespace_file:
    ensure  => present,
    content => template($namespace_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => Service['storm-backend-server'],
    require => [Package['storm-backend-mp']],
  }

  $properties_file='/etc/storm/backend-server/storm.properties'
  $properties_template_file='storm/etc/storm/backend-server/storm.properties.erb'

  file { $properties_file:
    ensure  => present,
    content => template($properties_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => Service['storm-backend-server'],
    require => [Package['storm-backend-mp']],
  }
}
