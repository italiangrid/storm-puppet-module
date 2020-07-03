# @!puppet.type.param
# @summary StoRM Backend puppet module
#
# @example Example of usage
#    class { 'storm::backend':
#      hostname => 'be.test.example',
#      db_root_password  => 'storm',
#      db_storm_password => 'bluemoon',
#      gsiftp_pool_members => [
#        {
#          'hostname' => 'gridftp.test.example',
#        },
#      ],
#      webdav_pool_members => [
#        {
#          'hostname' => 'webdav.test.example',
#        },
#      ],
#      storage_areas => [
#        {
#          'name'               => 'test.vo',
#          'root_path'          => '/storage/test.vo',
#          'access_points'      => ['/test.vo'],
#          'vos'                => ['test.vo'],
#          'storage_class'      => 'T0D1',
#          'online_size'        => 4,
#          'transfer_protocols' => ['file', 'gsiftp', 'https'],
#        },
#    }
#
# @param hostname
#   StoRM Backend Fully Qualified Domain Name
#
# @param db_root_password
#   MySQL root user password
#
# @param db_storm_username
#   The name of user used to connect to local database. Default: storm
#
# @param db_storm_password
#   Password for the user in `db_storm_username`
#
# @param xroot_hostname
#   Root server (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#
# @param xroot_port
#   Root server port (default value for all Storage Areas).
#
# @param gsiftp_pool_balance_strategy
#   Load balancing strategy for GridFTP server pool (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#   Available values: round-robin, smart-rr, random, weight. Default value: round-robin
#
# @param gsiftp_pool_members
#   Array of Storm::Backend::GsiftpPoolMember.
#   GridFTP servers pool list (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#
# @param webdav_pool_members
#   Array of Storm::Backend::WebdavPoolMember.
#   WebDAV endpoints pool list (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#
# @param srm_pool_members
#   Array of Storm::Backend::SrmPoolMember.
#   Frontend endpoints pool list (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#
# @param transfer_protocols
#   List of supported (and published) transfer protocols (default value for all Storage Areas). 
#   Note: you may change the settings for each SA acting on its configuration.
#
# @param fs_type
#   File System Type (default value for all Storage Areas).
#   Note: you may change the settings for each SA acting on its configuration.
#   Available values: posixfs, gpfs and test. Default value: posixfs
#
# @param storage_areas
#   List of supported Storage Areas. Array of Storm::Backend::StorageArea.
#
# @param frontend_public_host
#   StoRM Frontend service public host. It’s used by StoRM Info Provider to publish the SRM endpoint into the Resource BDII.
#   Default value: `hostname`
#
# @param frontend_port
#   StoRM Frontend service port. Default value: 8444
#
# @param directory_automatic_creation
#
# @param directory_writeperm
#
# @param rest_services_port
#   StoRM backend server rest port. Default value: 9998
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
#  Token used in communication to the StoRM Frontend
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
# @param info_sitename
#  It’s the human-readable name of your site used to set the Glue-SiteName attribute.
#
# @param info_storage_default_root
#  Default directory for Storage Areas.
#
# @param info_endpoint_quality_level
#
# @param info_webdav_pool_list
#
# @param info_frontend_host_list
#
class storm::backend (

  String $hostname,

  # Db
  String $db_root_password = $storm::backend::params::db_root_password,
  String $db_storm_username = $storm::backend::params::db_storm_username,
  String $db_storm_password = $storm::backend::params::db_storm_password,

  ### Default values for Storage Areas
  # 1. xroot
  String $xroot_hostname = lookup('storm::backend::xroot_hostname', String, undef, $hostname),
  Integer $xroot_port = $storm::backend::params::xroot_port,
  # 2. gridftp pool
  Storm::Backend::BalanceStrategy $gsiftp_pool_balance_strategy = $storm::backend::params::gsiftp_pool_balance_strategy,
  Array[Storm::Backend::GsiftpPoolMember] $gsiftp_pool_members = $storm::backend::params::gsiftp_pool_members,
  # 3. webdav pool
  Array[Storm::Backend::WebdavPoolMember] $webdav_pool_members = $storm::backend::params::webdav_pool_members,
  # 4. frontend pool
  Array[Storm::Backend::SrmPoolMember] $srm_pool_members = $storm::backend::params::srm_pool_members,
  # 5. transfer protocols
  Array[Storm::Backend::TransferProtocol] $transfer_protocols = $storm::backend::params::transfer_protocols,
  # 6. fs-type
  Storm::Backend::FsType $fs_type = $storm::backend::params::fs_type,

  # Storage Areas
  Array[Storm::Backend::StorageArea] $storage_areas = $storm::backend::params::storage_areas,

  # Frontend public host and port
  String $frontend_public_host = lookup('storm::backend::srm_hostname', String, undef, $hostname),
  Integer $frontend_port = $storm::backend::params::frontend_port,

  # Directory options
  Boolean $directory_automatic_creation = $storm::backend::params::directory_automatic_creation,
  Boolean $directory_writeperm = $storm::backend::params::directory_writeperm,

  # REST server conf
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

  # Info Provider
  String $info_sitename = $storm::backend::params::info_sitename,
  String $info_storage_default_root = $storm::backend::params::info_storage_default_root,
  Integer $info_endpoint_quality_level = $storm::backend::params::info_endpoint_quality_level,
  Array[Storm::Backend::WebdavPoolMember] $info_webdav_pool_list = lookup('storm::backend::info_webdav_pool_list',
    Array[Storm::Backend::WebdavPoolMember], undef, $webdav_pool_members),
  Array[Storm::Backend::SrmPoolMember] $info_frontend_host_list = lookup('storm::backend::info_frontend_host_list',
    Array[Storm::Backend::SrmPoolMember], undef, $srm_pool_members),

) inherits storm::backend::params {

  contain storm::backend::install
  contain storm::backend::config
  contain storm::backend::service

  class { 'bdii':
    selinux => false,
  }
  -> class { 'storm::db':
    fqdn_hostname  => $hostname,
    storm_username => $db_storm_username,
    storm_password => $db_storm_password,
  }
  -> Class['storm::backend::install']
  -> Class['storm::backend::config']
  -> Class['storm::backend::service']
  -> class { 'storm::info':
    backend_hostname       => $hostname,
    sitename               => $info_sitename,
    storage_default_root   => $info_storage_default_root,
    endpoint_quality_level => $info_endpoint_quality_level,
    frontend_public_host   => $frontend_public_host,
    frontend_port          => $frontend_port,
    rest_services_port     => $rest_services_port,
    webdav_pool_members    => $info_webdav_pool_list,
    srm_pool_members       => $info_frontend_host_list,
  }
}
