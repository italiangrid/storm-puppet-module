# @!puppet.type.param
# @summary StoRM Backend installation and configuration class.
#
# It's recommended to set your own database password and XMLRPC/REST security token.
# You also mainly need to configure your storage areas and the list of SRM, GridFTP and (in case) WebDAV endpoints.
#
# <table>
#   <thead> <tr> <th style="text-align: left;"> See also: </th> </tr> </thead>
#   <tbody>
#     <tr><td>
#       <a href="../puppet_data_type_aliases/Storm_3A_3ABackend_3A_3AStorageArea.html">Storm::Backend::StorageArea</a>
#     </td></tr>
#     <tr><td>
#         <a href="../puppet_data_type_aliases/Storm_3A_3ABackend_3A_3AFsType.html">Storm::Backend::FsType</a>
#     </td></tr>
#   </tbody>
# </table>
#
# @example Example of usage
#    class { 'storm::backend':
#      db_password => 'secret',
#      security_token => 'secret',
#      srm_pool_members => [
#        {
#          'hostname' => 'frontend.test.example',
#        }
#      ],
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
#      transfer_protocols => ['gsiftp', 'webdav'],
#      storage_areas => [
#        {
#          'name'               => 'test.vo',
#          'root_path'          => '/storage/test.vo',
#          'storage_class'      => 'T0D1',
#          'online_size'        => 4,
#        },
#      ],
#    }
#
# @example Example with a provided 'storm.properties'
#    class { 'storm::backend':
#      storm_properties_file => '/path/to/your/storm.properties',
#      db_password => 'my-secret-db-password',
#      srm_pool_members => [
#        {
#          'hostname' => 'frontend.test.example',
#        }
#      ],
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
#      transfer_protocols => ['gsiftp', 'webdav'],
#      storage_areas => [
#        {
#          'name'               => 'test.vo',
#          'root_path'          => '/storage/test.vo',
#          'storage_class'      => 'T0D1',
#          'online_size'        => 4,
#        },
#      ],
#    }
#
# @param storm_properties_file [String]
#   Use this to provide your own storm.properties file. This can be used for example when you're using the
#   latest module version to configure an old StoRM deployment. It's used when it has a non-empty value, and
#   it overwrites several other module parameters. Default value: empty string, that means not used.
#
# @param db_username [String]
#   The database connection user name to be passed to the JDBC driver to establish a connection. Default value: 'storm'
# @param db_password [String]
#   The database connection password to be passed to the JDBC driver to establish a connection. Default value: 'storm'.
# @param db_hostname [String]
#   Fully Qualified Domain Name of database hostname. It's initialized with fact ::fqdn.
# @param db_port [Integer]
#   Database connection URL port. Ignored if `storm_properties_file` is set. Default value: 3306.
# @param db_properties [String]
#   Database connection URL properties. Ignored if `storm_properties_file` is set. Default value: serverTimezone=UTC&autoReconnect=true
#
# @param db_pool_size [Integer]
#   The maximum number of active connections that can be allocated from database connection pool at the same time,
#   or negative for no limit. Ignored if `storm_properties_file` is set. Default value: -1.
# @param db_pool_min_idle [Integer]
#   The minimum number of connections that can remain idle in the pool, without extra ones being created, or zero
#   to create none. Ignored if `storm_properties_file` is set. Default value: 10.
# @param db_pool_max_wait_millis [Integer]
#   The maximum number of milliseconds that the pool will wait (when there are no available connections)
#   for a connection to be returned before throwing an exception, or -1 to wait indefinitely.
#   Ignored if `storm_properties_file` is set. Default value: 5000.
# @param db_pool_test_on_borrow [Boolean]
#   The indication of whether objects will be validated before being borrowed from the pool. If the
#   object fails to validate, it will be dropped from the pool, and we will attempt to borrow another.
#   Ignored if `storm_properties_file` is set. Default value: true.
# @param db_pool_test_while_idle [Boolean]
#   The indication of whether objects will be validated by the idle object evictor (if any). If an object
#   fails to validate, it will be dropped from the pool. Ignored if `storm_properties_file` is set. 
#   Default value: true.
#
# @param xroot_hostname [String]
#   If your deployment also consists of a xroot server, this is its FQDN in order to be used to provide valid
#   xroot TURL. Setting this parameter, the administrator provides a default value for all Storage Areas that
#   have 'xroot' as a transfer protocol. Note: you may overwrite this setting at single SA configuration level.
#   It's initialized with fact ::fqdn.
#
# @param xroot_port [Integer]
#   Xroot server port default value for all Storage Areas that have 'xroot' as a transfer protocol.
#   Note: you may overwrite this setting at single SA configuration level. Default value: 1094.
#
# @param gsiftp_pool_balance_strategy [Storm::Backend::BalanceStrategy]
#   Default load balancing strategy of GridFTP server pool for all the Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level.
#   Available values: 'round-robin', 'smart-rr', 'random', 'weight'. Default value: 'round-robin'.
#
# @param gsiftp_pool_members [Array[Storm::Backend::GsiftpPoolMember]]
#   Default GridFTP servers pool list for all Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param webdav_pool_members [Array[Storm::Backend::WebdavPoolMember]]
#   Default WebDAV endpoint pool list for all Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param srm_pool_members [Array[Storm::Backend::SrmPoolMember]]
#   Default SRM endpoint pool list for all Storage Areas (the Frontend list).
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param transfer_protocols [Array[Storm::Backend::TransferProtocol]]
#   Default list of supported (and published) transfer protocols for all Storage Areas. 
#   Note: you may overwrite this setting at single SA configuration level. Default value: ['file', 'gsiftp']
#
# @param fs_type [Storm::Backend::FsType]
#   Default File System Type value for all Storage Areas. Note: you may overwrite this setting at single SA configuration
#   level. Available values: 'posixfs', 'gpfs' and 'test'. Default value: 'posixfs'
#
# @param storage_areas [Array[Storm::Backend::StorageArea]]
#   The list of the managed storage areas. For each storage area a proper configuration must be provided.
#   Default value: empty array.
#
# @param rest_server_port [Integer]
#   REST services endpoint port on which the server is listening and accepting connections. 
#   Ignored if `storm_properties_file` is set. Default value: 9998.
# @param rest_server_max_threads [Integer]
#   The maximum number of parallel requests run by REST endpoint server.
#   Ignored if `storm_properties_file` is set. Default value: 100.
# @param rest_server_max_queue_size [Integer]
#   Internal REST services endpoint max queue size of accepted requests.
#   Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param xmlrpc_server_port [Integer]
#   XMLRPC server endpoint port where backend listens for incoming XML-RPC connections from Frontends(s).
#   Ignored if `storm_properties_file` is set. Default value: 8080.
# @param xmlrpc_server_max_threads [Integer]
#   Number of threads managing XML-RPC connection from Frontends(s). A well sized value for this parameter
#   have to be at least equal to the sum of the number of working threads in all FrontEend(s).
#   Ignored if `storm_properties_file` is set. Default value: 256.
# @param xmlrpc_server_max_queue_size [Integer]
#   Max number of accepted and queued XML-RPC connection from Frontends(s).
#   Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param du_service_enabled [Boolean]
#   Flag to enable Disk Usage service. The Disk Usage service is used for a periodic update of the used-space of
#   all the storage spaces that are not GPFS-with-quota-enabled. This periodic update consists of a
#   'du -s -b' executed on the storage area root directory. By default, the service is disabled.
#   Ignored if `storm_properties_file` is set. Default value: false.
# @param du_service_initial_delay [Integer]
#   The initial delay before the service is started (seconds). Ignored if `storm_properties_file` is set. 
#   Default value: 60.
# @param du_service_tasks_interval [Integer]
#   The interval in seconds between successive run. Ignored if `storm_properties_file` is set. Default value: 360.
# @param du_service_parallel_tasks_enabled [Boolean]
#   Enable/disable parallel execution for du tasks. Ignored if `storm_properties_file` is set. Default value: false.
#
# @param security_enabled [Boolean]
#   Whether the backend will require a token to be present for accepting XML-RPC/REST requests.
#   Ignored if `storm_properties_file` is set. Default value: true.
# @param security_token [String]
#   The token that the backend will require to be present for accepting XML-RPC/REST requests.
#   Mandatory if `security_enabled` is true. Ignored if `storm_properties_file` is set.
#   Default value: 'secret'
#
# @param sanity_checks_enabled [Boolean]
#   Enable/disable sanity checks during bootstrap phase. Ignored if `storm_properties_file` is set.
#   Default value: true.
#
# @param inprogress_requests_agent_delay [Integer]
#   Initial delay in seconds before starting the inprogress requests agent. This agent transits
#   expired get/put requests from SRM_FILE_PINNED or SRM_SPACE_AVAILABLE to a final state.
#   A request is expired if pinLifetime is reached. This agent also transits ptp that are stuck
#   in SRM_REQUEST_IN_PROGRESS for more than `ptp_expiration_time`. Ignored if `storm_properties_file` is set.
#   Default value: 10.
# @param inprogress_requests_agent_interval [Integer]
#   Time interval in seconds between two agent executions. Ignored if `storm_properties_file` is set. 
#   Default value: 300.
# @param inprogress_requests_agent_ptp_expiration_time [Integer]
#   Time in seconds to consider an in-progress ptp request as expired.
#   Ignored if `storm_properties_file` is set. Default value: 2592000.
#
# @param expired_spaces_agent_delay [Integer]
#   Initial delay in seconds before starting the expired spaces agent. The expired spaces agent removes 
#   expired reserved spaces. Ignored if `storm_properties_file` is set. Default value: 10.
# @param expired_spaces_agent_interval [Integer]
#   Time interval in seconds between two agent executions. Default value: 300.
#
# @param completed_requests_agent_enabled [Boolean]
#   Enable/Disable the completed requests agent. This agent deletes from database a bunch of `purge_size`
#   requests that are in a final status, older than `purge_age` seconds. Ignored if `storm_properties_file` is set.
#   Default value: true.
# @param completed_requests_agent_delay [Integer]
#   Initial delay in seconds before starting the requests garbage collection process.
#   Ignored if `storm_properties_file` is set. Default value: 10.
# @param completed_requests_agent_interval [Integer]
#   Time interval in seconds between two agent executions. Ignored if `storm_properties_file` is set.
#   Default value: 300.
# @param completed_requests_agent_purge_size [Integer]
#   The size of the maximum deleted requests at each agent execution. Ignored if `storm_properties_file` is set.
#   Default value: 800.
# @param completed_requests_agent_purge_age [Integer]
#   The age in seconds after that the completed requests can be considered as removable.
#   Ignored if `storm_properties_file` is set. Default value: 21600.
#
# @param requests_picker_agent_delay [Integer]
#   Initial delay in seconds before starting the requests garbage collection process.
#   Ignored if `storm_properties_file` is set. Default value: 1.
# @param requests_picker_agent_interval [Integer]
#   Time interval in seconds between two agent executions. Ignored if `storm_properties_file` is set. 
#   Default value: 2.
# @param requests_picker_agent_max_fetched_size [Integer]
#   Maximum number of picked requests at each execution. Ignored if `storm_properties_file` is set. 
#   Default value: 100.
#
# @param requests_scheduler_core_pool_size [Integer]
#   Requests scheduler worker pool base size. Ignored if `storm_properties_file` is set. Default value: 10.
# @param requests_scheduler_max_pool_size [Integer]
#   Requests scheduler worker pool max size. Ignored if `storm_properties_file` is set. Default value: 50.
# @param requests_scheduler_queue_size [Integer]
#   Requests scheduler worker pool queue size. Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param ptp_scheduler_core_pool_size [Integer]
#   Ptp requests scheduler worker pool base size. Ignored if `storm_properties_file` is set. Default value: 50.
# @param ptp_scheduler_max_pool_size [Integer]
#   Ptp requests scheduler worker pool max size. Ignored if `storm_properties_file` is set. Default value: 200.
# @param ptp_scheduler_queue_size [Integer]
#   Ptp requests scheduler worker pool queue size. Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param ptg_scheduler_core_pool_size [Integer]
#   Ptg requests scheduler worker pool base size. Ignored if `storm_properties_file` is set. Default value: 50.
# @param ptg_scheduler_max_pool_size [Integer]
#   Ptg requests scheduler worker pool max size. Ignored if `storm_properties_file` is set. Default value: 200.
# @param ptg_scheduler_queue_size [Integer]
#   Ptg requests scheduler worker pool queue size. Ignored if `storm_properties_file` is set. Default value: 2000.
#
# @param bol_scheduler_core_pool_size [Integer]
#   Bol requests scheduler worker pool base size. Ignored if `storm_properties_file` is set. Default value: 50.
# @param bol_scheduler_max_pool_size [Integer]
#   Bol requests scheduler worker pool max size. Ignored if `storm_properties_file` is set. Default value: 200.
# @param bol_scheduler_queue_size [Integer]
#   Bol requests scheduler worker pool queue size. Ignored if `storm_properties_file` is set. Default value: 2000.
#
# @param extraslashes_file [String]
#   Specify extra slashes (or a prefix) after the “authority” part of a File TURL.
#   Ignored if `storm_properties_file` is set. Default value: empty string.
# @param extraslashes_rfio [String]
#   Specify extra slashes (or a prefix) after the “authority” part of a RFIO TURL.
#   Ignored if `storm_properties_file` is set. Default value: empty string.
# @param extraslashes_gsiftp [String]
#   Specify extra slashes (or a prefix) after the “authority” part of a GsiFTP TURL.
#   Ignored if `storm_properties_file` is set. Default value: /.
# @param extraslashes_root [String]
#   Specify extra slashes (or a prefix) after the “authority” part of a Root TURL.
#   Ignored if `storm_properties_file` is set. Default value: /.
#
# @param skip_ptg_acl_setup [Boolean]
#   Skip ACL setup for PtG requests. Ignored if `storm_properties_file` is set.
#
# @param synch_ls_max_entries [Integer]
#   SRM ls maximum number of entries returned. Ignored if `storm_properties_file` is set. Default value: 2000.
# @param synch_ls_default_all_level_recursive [Boolean]
#   Enable/disable an all level response for SRM ls. Ignored if `storm_properties_file` is set.
#   Default value: false.
# @param synch_ls_default_num_levels [Integer]
#   Default number of levels returned by SRM ls. Ignored if `storm_properties_file` is set. Default value: 1.
# @param synch_ls_default_offset [Integer]
#   Default offset used by SRM ls. Ignored if `storm_properties_file` is set. Default value: 0.
# 
# @param files_default_size [Integer]
#   Default file size. Ignored if `storm_properties_file` is set. Default value: 1000000
# @param files_default_lifetime [Integer]
#   Default FileLifetime in seconds used for VOLATILE file in case of SRM request.
#   Ignored if `storm_properties_file` is set. Default value: 259200.
# @param files_default_overwrite [Enum['N', 'A', 'D']]
#   Default file overwrite mode to use upon srmPrepareToPut requests. Possible values are N (Never),
#   A (Always), D (when files Differs). Ignored if `storm_properties_file` is set. Default value: A.
# @param files_default_storagetype [Enum['V', 'D', 'P']]
#   Default File Storage Type to be used for srmPrepareToPut requests. Possible values are  V (Volatile),
#   P (Permanent) and  D (Durable). Ignored if `storm_properties_file` is set. Default value: P.
#
# @param directories_enable_automatic_creation [Boolean]
#   Enable/disable the automatic directory creation during srmPrepareToPut requests.
#   Ignored if `storm_properties_file` is set. Default value: false.
# @param directories_enable_writeperm_on_creation [Boolean]
#   Enable/disable write permission on directory created through srmMkDir requests.
#   Ignored if `storm_properties_file` is set. Default value: false.
#
# @param pinlifetime_default [Integer]
#   Default pinLifetime in seconds used for pinning files in case of srmPrepareToPut or srmPrapareToGet
#   requests. Ignored if `storm_properties_file` is set. Default value: 259200.
# @param pinlifetime_maximum [Integer]
#   Maximum allowed value for pinLifeTime. Values beyond the max will be dropped to max value.
#   Ignored if `storm_properties_file` is set. Default value: 1814400.
#
# @param hearthbeat_bookkeeping_enabled [Boolean]
#   Advanced settings for hearthbeat log. Enable/disable hearthbeat also bookkeeping.
#   Ignored if `storm_properties_file` is set. Default value: false
# @param hearthbeat_performance_measuring_enabled [Boolean]
#   Advanced settings for hearthbeat log. Enable/disable hearthbeat performance measuring for bookkeeping.
#   Ignored if `storm_properties_file` is set. Default value: false
# @param hearthbeat_period [Integer]
#   Advanced settings for hearthbeat log. Interval of logging executions in seconds.
#   Ignored if `storm_properties_file` is set. Default value: 60.
# @param hearthbeat_performance_logbook_time_interval [Integer]
#   Advanced settings for hearthbeat log. Performance logbook time interval.
#   Ignored if `storm_properties_file` is set. Default value: 15.
# @param hearthbeat_performance_glance_time_interval [Integer]
#   Advanced settings for hearthbeat log. Performance glance time interval.
#   Ignored if `storm_properties_file` is set. Default value: 15.
#
# @param info_quota_refresh_period
#   Time interval between two runs of GPFS quota agent. Ignored if `storm_properties_file` is set.
#   Default value: 900.
#
# @param http_turl_prefix
#   Ignored if `storm_properties_file` is set. Default value: empty string.
#
# @param server_pool_status_check_timeout
#   Lifetime in seconds of the cached status of a GsiFTP server in list.
#   Ignored if `storm_properties_file` is set. Default value: 20000.
#
# @param abort_maxloop
#   Max abort internal tentatives. Ignored if `storm_properties_file` is set. Default value: 10.
#
# @param ping_properties_filename
#   File name containing key-value properties that must be appended to SRM Ping body returned.
#   Ignored if `storm_properties_file` is set. Default value: ping-values.properties.
#
# @param info_config_file
#   Path of the Info Provider main configuration file auto-generated.
#
# @param info_sitename
#   It’s the human-readable name of your site used to set the Glue-SiteName attribute. Default value: 'StoRM site'.
#
# @param info_storage_default_root
#   Default directory for Storage Areas.
#
# @param info_endpoint_quality_level
#   Endpoint maturity level to be published by the StoRM info provider. Default value: 2.
#
# @param info_webdav_pool_list
#   List of published WebDAV endpoints.
#
# @param info_frontend_host_list
#   List of published SRM endpoints.
#
# @param jvm_options
#   Default value: '-Xms512m -Xmx512m'
#
# @param lcmaps_db_file
#   Default value: '/etc/storm/backend-server/lcmaps.db'.
#
# @param lcmaps_policy_name
#   Default value: 'standard'.
#
# @param lcmaps_log_file
#   Default value: '/var/log/storm/lcmaps.log'.
#
# @param lcmaps_debug_level
#   Default value: 0.
#
# @param storm_limit_nofile
#   Sets LimitNOFILE value. Default value: 65535.
#
# @param path_authz_db_file
#   If not an empty string, set the content of your path-authz.db file from this source path.
#   Default value: empty string.
#
# @param debug
#
class storm::backend (

  # Manage storm.properties
  String $storm_properties_file,

  # Database connection
  String $db_username,
  String $db_password,
  String $db_hostname,
  Integer $db_port,
  String $db_properties,
  # Database connection pool
  Integer $db_pool_size,
  Integer $db_pool_min_idle,
  Integer $db_pool_max_wait_millis,
  Boolean $db_pool_test_on_borrow,
  Boolean $db_pool_test_while_idle,

  ### Default values for Storage Areas
  # 1. xroot
  String $xroot_hostname,
  Integer $xroot_port,
  # 2. gridftp pool
  Storm::Backend::BalanceStrategy $gsiftp_pool_balance_strategy,
  Array[Storm::Backend::GsiftpPoolMember] $gsiftp_pool_members,
  # 3. webdav pool
  Array[Storm::Backend::WebdavPoolMember] $webdav_pool_members,
  # 4. frontend pool
  Array[Storm::Backend::SrmPoolMember] $srm_pool_members,
  # 5. transfer protocols
  Array[Storm::Backend::TransferProtocol] $transfer_protocols,
  # 6. fs-type
  Storm::Backend::FsType $fs_type,

  # Storage Areas
  Array[Storm::Backend::StorageArea] $storage_areas,

  # REST server
  Integer $rest_server_port,
  Integer $rest_server_max_threads,
  Integer $rest_server_max_queue_size,

  # XMLRPC server
  Integer $xmlrpc_server_port,
  Integer $xmlrpc_server_max_threads,
  Integer $xmlrpc_server_max_queue_size,

  # Security
  Boolean $security_enabled,
  String $security_token,

  # DU service
  Boolean $du_service_enabled,
  Integer $du_service_initial_delay,
  Integer $du_service_tasks_interval,
  Boolean $du_service_parallel_tasks_enabled,

  # Sanity checks
  Boolean $sanity_checks_enabled,

  # In progress requests agent
  Integer $inprogress_requests_agent_delay,
  Integer $inprogress_requests_agent_interval,
  Integer $inprogress_requests_agent_ptp_expiration_time,

  # Expired spaces agent
  Integer $expired_spaces_agent_delay,
  Integer $expired_spaces_agent_interval,

  # Completed requests agent
  Boolean $completed_requests_agent_enabled,
  Integer $completed_requests_agent_delay,
  Integer $completed_requests_agent_interval,
  Integer $completed_requests_agent_purge_size,
  Integer $completed_requests_agent_purge_age,

  # Requests picker agent
  Integer $requests_picker_agent_delay,
  Integer $requests_picker_agent_interval,
  Integer $requests_picker_agent_max_fetched_size,

  # Requests scheduler
  Integer $requests_scheduler_core_pool_size,
  Integer $requests_scheduler_max_pool_size,
  Integer $requests_scheduler_queue_size,
  # Ptp requests scheduler
  Integer $ptp_scheduler_core_pool_size,
  Integer $ptp_scheduler_max_pool_size,
  Integer $ptp_scheduler_queue_size,
  # Ptg requests scheduler
  Integer $ptg_scheduler_core_pool_size,
  Integer $ptg_scheduler_max_pool_size,
  Integer $ptg_scheduler_queue_size,
  # Bol requests scheduler
  Integer $bol_scheduler_core_pool_size,
  Integer $bol_scheduler_max_pool_size,
  Integer $bol_scheduler_queue_size,

  # Extraslashes
  String $extraslashes_file,
  String $extraslashes_rfio,
  String $extraslashes_gsiftp,
  String $extraslashes_root,

  # Skip setting ACL for Ptg requests
  Boolean $skip_ptg_acl_setup,

  # SRM ls settings
  Integer $synch_ls_max_entries,
  Boolean $synch_ls_default_all_level_recursive,
  Integer $synch_ls_default_num_levels,
  Integer $synch_ls_default_offset,

  # pinlifetime
  Integer $pinlifetime_default,
  Integer $pinlifetime_maximum,

  # files
  Integer $files_default_size,
  Integer $files_default_lifetime,
  Enum['N', 'A', 'D'] $files_default_overwrite,
  Enum['V', 'D', 'P'] $files_default_storagetype,

  # directories
  Boolean $directories_enable_automatic_creation,
  Boolean $directories_enable_writeperm_on_creation,

  # Hearthbeat
  Boolean $hearthbeat_bookkeeping_enabled,
  Boolean $hearthbeat_performance_measuring_enabled,
  Integer $hearthbeat_period,
  Integer $hearthbeat_performance_logbook_time_interval,
  Integer $hearthbeat_performance_glance_time_interval,

  # Others
  Integer $info_quota_refresh_period,
  String $http_turl_prefix,
  Integer $server_pool_status_check_timeout,
  Integer $abort_maxloop,
  String $ping_properties_filename,

  # Info Provider
  String $info_config_file,
  String $info_sitename,
  String $info_storage_default_root,
  Integer $info_endpoint_quality_level,

  # JVM options
  String $jvm_options,

  # LCMAPS
  String $lcmaps_db_file,
  String $lcmaps_policy_name,
  String $lcmaps_log_file,
  Integer $lcmaps_debug_level,

  # LimitNOFILE
  Integer $storm_limit_nofile,

  # manage path-authz.db
  String $path_authz_db_file,

  # debug
  Boolean $debug,

) {

  contain storm::backend::install
  contain storm::backend::configdb
  contain storm::backend::config
  contain storm::backend::service

  Class['storm::backend::install']
  -> Class['storm::backend::configdb']
  -> Class['storm::backend::config']
  -> Class['storm::backend::service']
}
