# @summary StoRM Frontend params class
#
class storm::backend::params (
) inherits storm::params {

  # Native libs gpfs
  $install_native_libs_gpfs = lookup('storm::backend::install_native_libs_gpfs', Boolean, undef, false)

  # Install MySQL and/or create database
  $install_mysql_and_create_database = lookup('storm::backend::install_mysql_and_create_database', Boolean, undef, false)
  $db_root_password = lookup('storm::backend::db_root_password', String, undef, 'storm')

  # Db
  $db_storm_username = lookup('storm::backend::db_storm_username', String, undef, 'storm')
  $db_storm_password = lookup('storm::backend::db_storm_password', String, undef, 'bluemoon')

  ### Default values for Storage Areas
  # 1. xroot
  $xroot_port = lookup('storm::backend::xroot_port', Integer, undef, 1094)
  # 2. gridftp pool
  $gsiftp_pool_balance_strategy = lookup('storm::backend::gsiftp_pool_balance_strategy',
    Storm::Backend::BalanceStrategy, undef, 'round-robin')
  $gsiftp_pool_members = lookup('storm::backend::gsiftp_pool_members',
    Array[Storm::Backend::GsiftpPoolMember], undef, [])
  # 3. webdav pool
  $webdav_pool_members = lookup('storm::backend::webdav_pool_members',
    Array[Storm::Backend::WebdavPoolMember], undef, [])
  # 4. frontend pool
  $srm_pool_members = lookup('storm::backend::srm_pool_members',
    Array[Storm::Backend::SrmPoolMember], undef, [])
  # 5. transfer protocols
  $transfer_protocols = lookup('storm::backend::transfer_protocols', Array[Storm::Backend::TransferProtocol], undef, ['file', 'gsiftp'])
  # 6. fs-type
  $fs_type = lookup('storm::backend::fs_type', Storm::Backend::FsType, undef, 'posixfs')

  # Storage Areas
  $storage_areas = lookup('storm::backend::storage_areas', Array[Storm::Backend::StorageArea], undef, [])

  # Frontend public host and port
  $frontend_port = lookup('storm::backend::frontend_port', Integer, undef, 8444)

  # StoRM Service Generic Behavior
  $directory_automatic_creation = lookup('storm::backend::directory_automatic_creation', Boolean, undef, false)
  $directory_writeperm = lookup('storm::backend::directory_writeperm', Boolean, undef, false)

  # REST Services parameter
  $rest_services_port = lookup('storm::backend::rest_services_port', Integer, undef, 9998)
  $rest_services_max_threads = lookup('storm::backend::rest_services_max_threads', Integer, undef, 100)
  $rest_services_max_queue_size = lookup('storm::backend::rest_services_max_queue_size', Integer, undef, 1000)

  # XMLRPC Server parameter
  $xmlrpc_unsecure_server_port = lookup('storm::backend::xmlrpc_unsecure_server_port', Integer, undef, 8080)
  $xmlrpc_maxthread = lookup('storm::backend::xmlrpc_maxthread', Integer, undef, 256)
  $xmlrpc_max_queue_size = lookup('storm::backend::xmlrpc_max_queue_size', Integer, undef, 1000)
  $xmlrpc_security_enabled = lookup('storm::backend::xmlrpc_security_enabled', Boolean, undef, true)
  $xmlrpc_security_token = lookup('storm::backend::xmlrpc_security_token', String, undef, 'secret')

  # Skip ACL setup for PTG requests
  $ptg_skip_acl_setup = lookup('storm::backend::ptg_skip_acl_setup', Boolean, undef, false)

  # pin lifetime
  $pinlifetime_default = lookup('storm::backend::pinlifetime_default', Integer, undef, 259200)
  $pinlifetime_maximum = lookup('storm::backend::pinlifetime_maximum', Integer, undef, 1814400)

  # sanity check enabled
  $sanity_check_enabled = lookup('storm::backend::sanity_check_enabled', Boolean, undef, true)

  # DU service
  $service_du_enabled = lookup('storm::backend::service_du_enabled', Boolean, undef, false)
  $service_du_delay = lookup('storm::backend::service_du_delay', Integer, undef, 60)
  $service_du_interval = lookup('storm::backend::service_du_interval', Integer, undef, 360)

  # ls max entries
  $max_ls_entries = lookup('storm::backend::max_ls_entries', Integer, undef, 2000)

  # Pinned Files cleaning parameters
  $gc_pinnedfiles_cleaning_delay = lookup('storm::backend::gc_pinnedfiles_cleaning_delay', Integer, undef, 10)
  $gc_pinnedfiles_cleaning_interval = lookup('storm::backend::gc_pinnedfiles_cleaning_interval', Integer, undef, 300)

  # Garbage Collector
  $gc_purge_enabled = lookup('storm::backend::gc_purge_enabled', Boolean, undef, true)
  $gc_purge_interval = lookup('storm::backend::gc_purge_interval', Integer, undef, 600)
  $gc_purge_size = lookup('storm::backend::gc_purge_size', Integer, undef, 800)
  $gc_expired_request_time = lookup('storm::backend::gc_expired_request_time', Integer, undef, 21600)
  $gc_expired_inprogress_time = lookup('storm::backend::gc_expired_inprogress_time', Integer, undef, 2592000)
  # Expired-Put-Requests-Agent parameters
  $gc_ptp_transit_interval = lookup('storm::backend::gc_ptp_transit_interval', Integer, undef, 300)
  $gc_ptp_transit_start_delay = lookup('storm::backend::gc_ptp_transit_start_delay', Integer, undef, 10)

  # extraslashes
  $extraslashes_file = lookup('storm::backend::extraslashes_file', String, undef, '')
  $extraslashes_root = lookup('storm::backend::extraslashes_root', String, undef, '/')
  $extraslashes_gsiftp = lookup('storm::backend::extraslashes_gsiftp', String, undef, '/')

  # Db Connection Pool
  $db_connection_pool_enabled = lookup('storm::backend::db_connection_pool_enabled', Boolean, undef, true)
  $db_connection_pool_max_active = lookup('storm::backend::params::db_connection_pool_max_active', Integer, undef, 200)
  $db_connection_pool_max_wait = lookup('storm::backend::params::db_connection_pool_max_wait', Integer, undef, 50)

  # Asynch Picker
  $asynch_db_reconnect_period = lookup('storm::backend::asynch_db_reconnect_period', Integer, undef, 18000)
  $asynch_db_delay_period = lookup('storm::backend::asynch_db_delay_period', Integer, undef, 30)
  $asynch_picking_initial_delay = lookup('storm::backend::asynch_picking_initial_delay', Integer, undef, 1)
  $asynch_picking_time_interval = lookup('storm::backend::asynch_picking_time_interval', Integer, undef, 2)
  $asynch_picking_max_batch_size = lookup('storm::backend::asynch_picking_max_batch_size', Integer, undef, 100)

  # Scheduler pools
  $requests_scheduler_core_size = lookup('storm::backend::requests_scheduler_core_size', Integer, undef, 50)
  $requests_scheduler_max_size = lookup('storm::backend::requests_scheduler_core_size', Integer, undef, 200)
  $requests_scheduler_queue_size = lookup('storm::backend::requests_scheduler_core_size', Integer, undef, 2000)
  $ptp_requests_scheduler_core_size = lookup('storm::backend::ptp_requests_scheduler_core_size', Integer, undef, 50)
  $ptp_requests_scheduler_max_size = lookup('storm::backend::ptp_requests_scheduler_max_size', Integer, undef, 200)
  $ptp_requests_scheduler_queue_size = lookup('storm::backend::ptp_requests_scheduler_queue_size', Integer, undef, 1000)
  $ptg_requests_scheduler_core_size = lookup('storm::backend::ptg_requests_scheduler_core_size', Integer, undef, 50)
  $ptg_requests_scheduler_max_size = lookup('storm::backend::ptg_requests_scheduler_max_size', Integer, undef, 200)
  $ptg_requests_scheduler_queue_size = lookup('storm::backend::ptg_requests_scheduler_queue_size', Integer, undef, 2000)
  $bol_requests_scheduler_core_size = lookup('storm::backend::bol_requests_scheduler_core_size', Integer, undef, 50)
  $bol_requests_scheduler_max_size = lookup('storm::backend::bol_requests_scheduler_max_size', Integer, undef, 200)
  $bol_requests_scheduler_queue_size = lookup('storm::backend::bol_requests_scheduler_queue_size', Integer, undef, 2000)

  # Info Provider
  $info_config_file = lookup('storm::backend::info_config_file', String, undef, '/etc/storm/info-provider/storm-yaim-variables.conf')
  $info_sitename = lookup('storm::backend::info_sitename', String, undef, 'StoRM site')
  $info_storage_default_root = lookup('storm::backend::info_storage_default_root', String, undef, '/storage')
  $info_endpoint_quality_level = lookup('storm::backend::info_endpoint_quality_level', Integer, undef, 2)
}
