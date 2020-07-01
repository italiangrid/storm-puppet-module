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

  $ptg_skip_acl_setup = $storm::backend::ptg_skip_acl_setup,

  $pinlifetime_default = $storm::backend::pinlifetime_default,
  $pinlifetime_maximum = $storm::backend::pinlifetime_maximum,

  $sanity_check_enabled = $storm::backend::sanity_check_enabled,

  $service_du_enabled = $storm::backend::service_du_enabled,
  $service_du_delay = $storm::backend::service_du_delay,
  $service_du_interval = $storm::backend::service_du_interval,

  $synchcall_max_ls_entries = $storm::backend::synchcall_max_ls_entries,

  $gc_pinnedfiles_cleaning_delay = $storm::backend::gc_pinnedfiles_cleaning_delay,
  $gc_pinnedfiles_cleaning_interval = $storm::backend::gc_pinnedfiles_cleaning_interval,

  $gc_purge_enabled = $storm::backend::gc_purge_enabled,
  $gc_purge_interval = $storm::backend::gc_purge_interval,
  $gc_purge_size = $storm::backend::gc_purge_size,
  $gc_expired_request_time = $storm::backend::gc_expired_request_time,
  $gc_ptp_transit_interval = $storm::backend::gc_ptp_transit_interval,
  $gc_ptp_transit_start_delay = $storm::backend::gc_ptp_transit_start_delay,

  $extraslashes_file = $storm::backend::extraslashes_file,
  $extraslashes_root = $storm::backend::extraslashes_root,
  $extraslashes_gsiftp = $storm::backend::extraslashes_gsiftp,

  $db_connection_pool_enabled = $storm::backend::db_connection_pool_enabled,
  $db_connection_pool_max_active = $storm::backend::db_connection_pool_max_active,
  $db_connection_pool_max_wait = $storm::backend::db_connection_pool_max_wait,

  $asynch_db_reconnect_period = $storm::backend::asynch_db_reconnect_period,
  $asynch_db_delay_period = $storm::backend::asynch_db_delay_period,
  $asynch_picking_initial_delay = $storm::backend::asynch_picking_initial_delay,
  $asynch_picking_time_interval = $storm::backend::asynch_picking_time_interval,
  $asynch_picking_max_batch_size = $storm::backend::asynch_picking_max_batch_size,

  $requests_scheduler_core_size = $storm::backend::requests_scheduler_core_size,
  $requests_scheduler_max_size = $storm::backend::requests_scheduler_max_size,
  $requests_scheduler_queue_size = $storm::backend::requests_scheduler_queue_size,
  $ptp_requests_scheduler_core_size = $storm::backend::ptp_requests_scheduler_core_size,
  $ptp_requests_scheduler_max_size = $storm::backend::ptp_requests_scheduler_max_size,
  $ptp_requests_scheduler_queue_size = $storm::backend::ptp_requests_scheduler_queue_size,
  $ptg_requests_scheduler_core_size = $storm::backend::ptg_requests_scheduler_core_size,
  $ptg_requests_scheduler_max_size = $storm::backend::ptg_requests_scheduler_max_size,
  $ptg_requests_scheduler_queue_size = $storm::backend::ptg_requests_scheduler_queue_size,
  $bol_requests_scheduler_core_size = $storm::backend::bol_requests_scheduler_core_size,
  $bol_requests_scheduler_max_size = $storm::backend::bol_requests_scheduler_max_size,
  $bol_requests_scheduler_queue_size = $storm::backend::bol_requests_scheduler_queue_size,

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
