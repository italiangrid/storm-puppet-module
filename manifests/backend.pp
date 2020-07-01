# @!puppet.type.param
# @summary StoRM Backend puppet module
#
# @example Example of usage
#    class { 'storm::backend':
#    }
#
# @param hostname
#   StoRM Backend Fully Qualified Domain Name
#
# @param info
#
# @param database
#
# @param rfio_hostname
#
# @param rfio_port
#
# @param xroot_hostname
#
# @param xroot_port
#
# @param gsiftp_pool_balance_strategy
#
# @param gsiftp_pool_members
#
# @param webdav_pool_members
#
# @param srm_pool_members
#
# @param storage_areas
#
# @param frontend_public_host
#
# @param frontend_port
#
# @param directory_automatic_creation
#
# @param directory_writeperm
#
# @param rest_services_port
#
# @param rest_services_max_threads
#
# @param rest_services_max_queue_size
#
# @param synchcall_xmlrpc_unsecure_server_port
#
# @param synchcall_xmlrpc_maxthread
#
# @param synchcall_xmlrpc_max_queue_size
#
# @param synchcall_xmlrpc_security_enabled
#
# @param synchcall_xmlrpc_security_token
#
# @param ptg_skip_acl_setup
#
# @param pinlifetime_default
#
# @param pinlifetime_maximum
#
# @param sanity_check_enabled
#
# @param service_du_enabled
#
# @param service_du_delay
#
# @param service_du_interval
#
# @param synchcall_max_ls_entries
#
# @param gc_pinnedfiles_cleaning_delay
#
# @param gc_pinnedfiles_cleaning_interval
#
# @param gc_purge_enabled
#
# @param gc_purge_interval
#
# @param gc_purge_size
#
# @param gc_expired_request_time
#
# @param gc_ptp_transit_interval
#
# @param gc_ptp_transit_start_delay
#
# @param extraslashes_file
#
# @param extraslashes_root
#
# @param extraslashes_gsiftp
#
# @param db_connection_pool_enabled
#
# @param db_connection_pool_max_active
#
# @param db_connection_pool_max_wait
#
# @param asynch_db_reconnect_period
#
# @param asynch_db_delay_period
#
# @param asynch_picking_initial_delay
#
# @param asynch_picking_time_interval
#
# @param asynch_picking_max_batch_size
#
# @param requests_scheduler_core_size
#
# @param requests_scheduler_max_size
#
# @param requests_scheduler_queue_size
#
# @param ptp_requests_scheduler_core_size
#
# @param ptp_requests_scheduler_max_size
#
# @param ptp_requests_scheduler_queue_size
#
# @param ptg_requests_scheduler_core_size
#
# @param ptg_requests_scheduler_max_size
#
# @param ptg_requests_scheduler_queue_size
#
# @param bol_requests_scheduler_core_size
#
# @param bol_requests_scheduler_max_size
#
# @param bol_requests_scheduler_queue_size
#
class storm::backend (

  String $hostname,

  Storm::Backend::Info $info = $storm::backend::params::info,
  Storm::Backend::Database $database = $storm::backend::params::database,

  String $rfio_hostname = lookup('storm::backend::rfio_hostname', String, undef, $hostname),
  Integer $rfio_port = $storm::backend::params::rfio_port,

  String $xroot_hostname = lookup('storm::backend::xroot_hostname', String, undef, $hostname),
  Integer $xroot_port = $storm::backend::params::xroot_port,

  Storm::Backend::BalanceStrategy $gsiftp_pool_balance_strategy = $storm::backend::params::gsiftp_pool_balance_strategy,
  Array[Storm::Backend::GsiftpPoolMember] $gsiftp_pool_members = $storm::backend::params::gsiftp_pool_members,
  Array[Storm::Backend::WebdavPoolMember] $webdav_pool_members = $storm::backend::params::webdav_pool_members,
  Array[Storm::Backend::SrmPoolMember] $srm_pool_members = $storm::backend::params::srm_pool_members,

  Array[Storm::Backend::StorageArea] $storage_areas = $storm::backend::params::storage_areas,

  String $frontend_public_host = lookup('storm::backend::srm_hostname', String, undef, $hostname),
  Integer $frontend_port = $storm::backend::params::frontend_port,

  Boolean $directory_automatic_creation = $storm::backend::params::directory_automatic_creation,
  Boolean $directory_writeperm = $storm::backend::params::directory_writeperm,

  Integer $rest_services_port = $storm::backend::params::rest_services_port,
  Integer $rest_services_max_threads = $storm::backend::params::rest_services_max_threads,
  Integer $rest_services_max_queue_size = $storm::backend::params::rest_services_max_queue_size,

  # XMLRPC Server parameter
  Integer $synchcall_xmlrpc_unsecure_server_port = $storm::backend::params::synchcall_xmlrpc_unsecure_server_port,
  Integer $synchcall_xmlrpc_maxthread = $storm::backend::params::synchcall_xmlrpc_maxthread,
  Integer $synchcall_xmlrpc_max_queue_size = $storm::backend::params::synchcall_xmlrpc_max_queue_size,
  Boolean $synchcall_xmlrpc_security_enabled = $storm::backend::params::synchcall_xmlrpc_security_enabled,
  String $synchcall_xmlrpc_security_token = $storm::backend::params::synchcall_xmlrpc_security_token,

  # Skip ACL setup for PTG requests
  Boolean $ptg_skip_acl_setup = $storm::backend::params::ptg_skip_acl_setup,

  # Pin lifetime
  Integer $pinlifetime_default = $storm::backend::params::pinlifetime_default,
  Integer $pinlifetime_maximum = $storm::backend::params::pinlifetime_maximum,

  # Sanity checks
  Boolean $sanity_check_enabled = $storm::backend::params::sanity_check_enabled,

  # DU service
  Boolean $service_du_enabled = $storm::backend::params::service_du_enabled,
  Integer $service_du_delay = $storm::backend::params::service_du_delay,
  Integer $service_du_interval = $storm::backend::params::service_du_interval,

  # Ls max entries
  Integer $synchcall_max_ls_entries = $storm::backend::params::synchcall_max_ls_entries,

  # Pinned Files cleaning parameters
  Integer $gc_pinnedfiles_cleaning_delay = $storm::backend::params::gc_pinnedfiles_cleaning_delay,
  Integer $gc_pinnedfiles_cleaning_interval = $storm::backend::params::gc_pinnedfiles_cleaning_interval,

  # Garbage Collector
  Boolean $gc_purge_enabled = $storm::backend::params::gc_purge_enabled,
  Integer $gc_purge_interval = $storm::backend::params::gc_purge_interval,
  Integer $gc_purge_size = $storm::backend::params::gc_purge_size,
  Integer $gc_expired_request_time = $storm::backend::params::gc_expired_request_time,
  Integer $gc_ptp_transit_interval = $storm::backend::params::gc_ptp_transit_interval,
  Integer $gc_ptp_transit_start_delay = $storm::backend::params::gc_ptp_transit_start_delay,

  # Extraslashes
  String $extraslashes_file = $storm::backend::params::extraslashes_file,
  String $extraslashes_root = $storm::backend::params::extraslashes_root,
  String $extraslashes_gsiftp = $storm::backend::params::extraslashes_gsiftp,

  # Db Connection Pool
  Boolean $db_connection_pool_enabled = $storm::backend::params::db_connection_pool_enabled,
  Integer $db_connection_pool_max_active = $storm::backend::params::db_connection_pool_max_active,
  Integer $db_connection_pool_max_wait = $storm::backend::params::db_connection_pool_max_wait,

  # Asynch Picker
  Integer $asynch_db_reconnect_period = $storm::backend::params::asynch_db_reconnect_period,
  Integer $asynch_db_delay_period = $storm::backend::params::asynch_db_delay_period,
  Integer $asynch_picking_initial_delay = $storm::backend::params::asynch_picking_initial_delay,
  Integer $asynch_picking_time_interval = $storm::backend::params::asynch_picking_time_interval,
  Integer $asynch_picking_max_batch_size = $storm::backend::params::asynch_picking_max_batch_size,

  # Requests schedulers
  Integer $requests_scheduler_core_size = $storm::backend::params::requests_scheduler_core_size,
  Integer $requests_scheduler_max_size = $storm::backend::params::requests_scheduler_max_size,
  Integer $requests_scheduler_queue_size = $storm::backend::params::requests_scheduler_queue_size,
  Integer $ptp_requests_scheduler_core_size = $storm::backend::params::ptp_requests_scheduler_core_size,
  Integer $ptp_requests_scheduler_max_size = $storm::backend::params::ptp_requests_scheduler_max_size,
  Integer $ptp_requests_scheduler_queue_size = $storm::backend::params::ptp_requests_scheduler_queue_size,
  Integer $ptg_requests_scheduler_core_size = $storm::backend::params::ptg_requests_scheduler_core_size,
  Integer $ptg_requests_scheduler_max_size = $storm::backend::params::ptg_requests_scheduler_max_size,
  Integer $ptg_requests_scheduler_queue_size = $storm::backend::params::ptg_requests_scheduler_queue_size,
  Integer $bol_requests_scheduler_core_size = $storm::backend::params::bol_requests_scheduler_core_size,
  Integer $bol_requests_scheduler_max_size = $storm::backend::params::bol_requests_scheduler_max_size,
  Integer $bol_requests_scheduler_queue_size = $storm::backend::params::bol_requests_scheduler_queue_size,

) inherits storm::backend::params {

  contain storm::backend::install
  contain storm::backend::config
  contain storm::backend::service

  class { 'bdii':
    selinux => false,
  }
  -> class { 'storm::db':
    fqdn_hostname  => $hostname,
    storm_username => $database[storm_username],
    storm_password => $database[storm_password],
  }
  -> Class['storm::backend::install']
  -> Class['storm::backend::config']
  -> Class['storm::backend::service']
  -> class { 'storm::info':
    backend_hostname     => $hostname,
    sitename             => $info[sitename],
    storage_default_root => $info[storage_default_root],
    frontend_public_host => $frontend_public_host,
    frontend_port        => $frontend_port,
    rest_services_port   => $rest_services_port,
    webdav_pool_members  => $webdav_pool_members,
    srm_pool_members     => $srm_pool_members,
  }
}
