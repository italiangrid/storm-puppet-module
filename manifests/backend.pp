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
#      db => {
#        password => 'secret',
#      },
#      security    => {
#        token => 'secret',
#      },
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
#      db => {
#        password => 'my-secret-db-password',
#      },
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
# @param db [Hash]
#   Database connection settings
# 
# @option db [String] :username
#   The connection user name to be passed to the JDBC driver to establish a connection. Default value: 'storm'
# @option db [String] :password
#   The connection password to be passed to the JDBC driver to establish a connection. Default value: 'storm'.
# @option db [String] :hostname
#   Fully Qualified Domain Name of database hostname. It's initialized with fact ::fqdn.
# @option db [Integer] :port
#   Database connection URL port. Ignored if `storm_properties_file` is set. Default value: 3306.
#
# @example Database connection settings
#   storm::backend::db:
#     username: 'storm'
#     password: 'storm'
#     hostname: 'storm.example.com'
#     port: 3306
#     properties: 'serverTimezone=UTC&autoReconnect=true'
#
# @param db_pool [Hash]
#   Database connection pool settings. Ignored if `storm_properties_file` is set.
#
# @option db_pool [Integer] :size
#   The maximum number of active connections that can be allocated from database connection pool at the same time,
#   or negative for no limit. Default value: -1.
# @option db_pool [Integer] :min_idle
#   The minimum number of connections that can remain idle in the pool, without extra ones being created, or zero
#   to create none. Default value: 10.
# @option db_pool [Integer] :max_wait_millis
#   The maximum number of milliseconds that the pool will wait (when there are no available connections)
#   for a connection to be returned before throwing an exception, or -1 to wait indefinitely. Default value: 5000.
# @option db_pool [Boolean] :test_on_borrow
#   The indication of whether objects will be validated before being borrowed from the pool. If the
#   object fails to validate, it will be dropped from the pool, and we will attempt to borrow another.
#   Default value: true.
# @option db_pool [Boolean] :test_while_idle
#   The indication of whether objects will be validated by the idle object evictor (if any). If an object
#   fails to validate, it will be dropped from the pool. Default value: true.
#
# @example Database connection pool settings
#   storm::backend::db_pool:
#     size: -1
#     min_idle: 10
#     max_wait_millis: 5000
#     test_on_borrow: true
#     test_while_idle: true
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
# @param rest_server [Hash]
#   REST services endpoint settings. Ignored if `storm_properties_file` is set.
#
# @option rest_server [Integer] :port
#   REST endpoint port on which the server is listening and accepting connections. Default value: 9998.
# @option rest_server [Integer] :max_threads
#   The maximum number of parallel requests run by REST endpoint server. Default value: 100.
# @option rest_server [Integer] :max_queue_size
#   Internal REST services endpoint max queue size of accepted requests. Default value: 1000.
#
# @param xmlrpc_server [Hash]
#   XMLRPC server endpoint settings. Ignored if `storm_properties_file` is set.
#
# @option xmlrpc_server [Integer] :port
#   Port to listen on for incoming XML-RPC connections from Frontends(s). Default value: 8080.
# @option xmlrpc_server [Integer] :max_threads
#   Number of threads managing XML-RPC connection from Frontends(s). A well sized value for this parameter
#   have to be at least equal to the sum of the number of working threads in all FrontEend(s).
#   Default value: 256.
# @option xmlrpc_server [Integer] :max_queue_size
#   Max number of accepted and queued XML-RPC connection from Frontends(s). Default value: 1000.
#
# @param du_service [Hash]
#   Disk usage service settings. Disk Usage service is used for a periodic update of the used-space of
#   all the storage spaces that are not GPFS-with-quota-enabled. This periodic update consists of a
#   'du -s -b' executed on the storage area root directory. By default, the service is disabled.
#   Ignored if `storm_properties_file` is set.
#
# @option du_service [Boolean] :enabled
#   Flag to enable disk usage service. Default value: false.
# @option du_service [Integer] :initial_delay
#   The initial delay before the service is started (seconds). Default value: 60.
# @option du_service [Integer] :tasks_interval
#   The interval in seconds between successive run. Default value: 360.
# @option du_service [Boolean] :parallel_tasks_enabled
#   Enable/disable parallel execution for du tasks. Default value: false.
#
# @param security [Hash]
#
# @option security [Boolean] :enabled
#   Whether the backend will require a token to be present for accepting XML-RPC requests.
#   Ignored if `storm_properties_file` is set. Default value: true.
# @option security [String] :token
#   The token that the backend will require to be present for accepting XML-RPC requests.
#   Mandatory if `synchcall.xmlrpc.token.enabled` is true. Ignored if `storm_properties_file` is set.
#   Default value: 'secret'
#
# @param sanity_checks_enabled [Boolean]
#   Enable/disable sanity checks during bootstrap phase. Ignored if `storm_properties_file` is set.
#   Default value: true.
#
# @param inprogress_requests_agent [Hash]
#   The inprogress requests agent transits expired get/put requests from SRM_FILE_PINNED or SRM_SPACE_AVAILABLE 
#   to a final state. A request is expired if pinLifetime is reached. This agent also transits ptp that are stuck
#   in SRM_REQUEST_IN_PROGRESS for more than `ptp_expiration_time`. Ignored if `storm_properties_file` is set.
#
# @option inprogress_requests_agent [Integer] :delay
#   Initial delay in seconds before starting the requests garbage collection process. Default value: 10.
# @option inprogress_requests_agent [Integer] :interval
#   Time interval in seconds between two agent executions. Default value: 300.
# @option inprogress_requests_agent [Integer] :ptp_expiration_time
#   Time in seconds to consider an in-progress ptp request as expired. Default value: 2592000.
#
# @param expired_spaces_agent [Hash]
#   The expired spaces agent remove expired reserved spaces. Ignored if `storm_properties_file` is set.
#
# @option expired_spaces_agent [Integer] :delay
#   Initial delay in seconds before starting the requests garbage collection process. Default value: 10.
# @option expired_spaces_agent [Integer] :interval
#   Time interval in seconds between two agent executions. Default value: 300.
#
# @param completed_requests_agent [Hash]
#   The completed requests agent deletes from database a bunch of `purge_size` requests that are in a final
#   status from more than `purge_age` seconds. Ignored if `storm_properties_file` is set.
#
# @option completed_requests_agent [Boolean] :enabled
#   Enable/Disable the agent. Default value: true.
# @option completed_requests_agent [Integer] :delay
#   Initial delay in seconds before starting the requests garbage collection process. Default value: 10.
# @option completed_requests_agent [Integer] :interval
#   Time interval in seconds between two agent executions. Default value: 300.
# @option completed_requests_agent [Integer] :purge_size
#   The size of the maximum deleted requests at each agent execution.
# @option completed_requests_agent [Integer] :purge_age
#   The age of the completed requests after that they can be considered as removable.
#
# @param requests_picker_agent [Hash]
#   Requests picker advanced settings. Ignored if `storm_properties_file` is set.
#
# @option requests_picker_agent [Integer] :delay
#   Initial delay in seconds before starting the requests garbage collection process. Default value: 1.
# @option requests_picker_agent [Integer] :interval
#   Time interval in seconds between two agent executions. Default value: 2.
# @option requests_picker_agent [Integer] :max_fetched_size
#   Maximum number of picked requests at each execution.
#
# @param requests_scheduler [Hash]
#   Requests scheduler advanced settings. Ignored if `storm_properties_file` is set.
#
# @option requests_scheduler [Integer] :core_pool_size
#   Requests scheduler worker pool base size. Default value: 10.
# @option requests_scheduler [Integer] :max_pool_size
#   Requests scheduler worker pool max size. Default value: 50.
# @option requests_scheduler [Integer] :queue_size
#   Requests scheduler worker pool queue size. Default value: 1000.
#
# @param ptp_scheduler [Hash]
#   Ptp requests scheduler advanced settings. Ignored if `storm_properties_file` is set.
#
# @option ptp_scheduler [Integer] :core_pool_size
#   Ptp requests scheduler worker pool base size. Default value: 50.
# @option ptp_scheduler [Integer] :max_pool_size
#   Ptp requests scheduler worker pool max size. Default value: 200.
# @option ptp_scheduler [Integer] :queue_size
#   Ptp requests scheduler worker pool queue size. Default value: 1000.
#
# @param ptg_scheduler [Hash]
#   Ptg requests scheduler advanced settings. Ignored if `storm_properties_file` is set.
#
# @option ptg_scheduler [Integer] :core_pool_size
#   Ptg requests scheduler worker pool base size. Default value: 50.
# @option ptg_scheduler [Integer] :max_pool_size
#   Ptg requests scheduler worker pool max size. Default value: 200.
# @option ptg_scheduler [Integer] :queue_size
#   Ptg requests scheduler worker pool queue size. Default value: 2000.
#
# @param bol_scheduler [Hash]
#   Bol requests scheduler advanced settings. Ignored if `storm_properties_file` is set.
#
# @option bol_scheduler [Integer] :core_pool_size
#   Bol requests scheduler worker pool base size. Default value: 50.
# @option bol_scheduler [Integer] :max_pool_size
#   Bol requests scheduler worker pool max size. Default value: 200.
# @option bol_scheduler [Integer] :queue_size
#   Bol requests scheduler worker pool queue size. Default value: 2000.
#
# @param extraslashes [Hash]
#   Specify extra slashes (or a prefix) after the “authority” part of a TURL for several protocols.
#   Ignored if `storm_properties_file` is set.
#
# @option extraslashes [String] :file
#   Default value: empty string.
# @option extraslashes [String] :rfio
#   Default value: empty string.
# @option extraslashes [String] :gsiftp
#   Default value: /.
# @option extraslashes [String] :root
#   Default value: /.
#
# @param skip_ptg_acl_setup [Boolean]
#   Skip ACL setup for PtG requests. Ignored if `storm_properties_file` is set.
#
# @param synch_ls [Hash]
#   SRM ls advanced settings. Ignored if `storm_properties_file` is set.
#
# @option synch_ls [Integer] :max_entries
#   Maximum number of entries returned. Default value: 2000.
# @option synch_ls [Boolean] :default_all_level_recursive
#   Enable/disable returnin an all level response. Default value: false.
# @option synch_ls [Integer] :default_num_levels
#   Default number of levels returned. Default value: 1.
# @option synch_ls [Integer] :default_offset
#   Default offset used. Default value: 0.
#
# @param files [Hash]
#   Advanced files settings. Ignored if `storm_properties_file` is set.
# 
# @option files [Integer] :default_size
#   Default file size. Default value: 1000000
# @option files [Integer] :default_lifetime
#   Default FileLifetime in seconds used for VOLATILE file in case of SRM request. Default value: 259200.
# @option files [Integer] :default_overwrite
#   Default file overwrite mode to use upon srmPrepareToPut requests.
#   Possible values are N (Never), A (Always), D (when files Differs). Default value: A.
# @option files [Integer] :default_storagetype
#   Default File Storage Type to be used for srmPrepareToPut requests.
#   Possible values are  V (Volatile), P (Permanent) and  D (Durable). Default value: P.
#
# @param directories [Hash]
#   Advanced directories settings. Ignored if `storm_properties_file` is set.
#
# @option directories [Boolean] :enable_automatic_creation
#   Enable/disable the automatic directory creation during srmPrepareToPut requests. Default value: false.
# @option directories [Boolean] :enable_writeperm_on_creation
#   Enable/disable write permission on directory created through srmMkDir requests. Default value: false.
#
# @param pinlifetime [Hash]
#
# @option pinlifetime [Integer] :default
#   Default pinLifetime in seconds used for pinning files in case of srmPrepareToPut or srmPrapareToGet
#   requests. Default value: 259200.
# @option pinlifetime [Integer] :maximum
#   Maximum allowed value for pinLifeTime. Values beyond the max will be dropped to max value.
#   Default value: 1814400.
#
# @param hearthbeat [Hash]
#   Advanced settings for hearthbeat log.
#
# @option hearthbeat [Boolean] :bookkeeping_enabled
#   Enable/disable hearthbeat also bookkeeping. Default value: false
# @option hearthbeat [Boolean] :performance_measuring_enabled
#   Enable/disable hearthbeat performance measuring for bookkeeping. Default value: false
# @option hearthbeat [Integer] :period
#   Interval of logging executions in seconds. Default value: 60.
# @option hearthbeat [Integer] :performance_logbook_time_interval
#   Performance logbook time interval. Default value: 15.
# @option hearthbeat [Integer] :performance_glance_time_interval
#   Performance glance time interval. Default value: 15.
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
# @param info_quota_refresh_period
#
# @param http_turl_prefix
#
# @param server_pool_status_check_timeout
# @param abort_maxloop
# @param ping_properties_filename
# @param debug
#
class storm::backend (

  # Manage storm.properties
  String $storm_properties_file,

  # Database connection
  Hash $db,
  # Database connection pool
  Hash $db_pool,

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
  Hash $rest_server,

  # XMLRPC server
  Hash $xmlrpc_server,

  # DU service
  Hash $du_service,

  # Sanity checks
  Boolean $sanity_checks_enabled,

  # Security
  Hash $security,

  # In progress requests agent
  Hash $inprogress_requests_agent,

  # Expired spaces agent
  Hash $expired_spaces_agent,

  # Completed requests agent
  Hash $completed_requests_agent,

  # Requests picker agent
  Hash $requests_picker_agent,

  # Requests scheduler
  Hash $requests_scheduler,
  # Ptp requests scheduler
  Hash $ptp_scheduler,
  # Ptg requests scheduler
  Hash $ptg_scheduler,
  # Bol requests scheduler
  Hash $bol_scheduler,

  # Extraslashes
  Hash $extraslashes,

  # Skip setting ACL for Ptg requests
  Boolean $skip_ptg_acl_setup,

  # SRM ls settings
  Hash $synch_ls,

  # pinlifetime
  Hash $pinlifetime,

  # files
  Hash $files,
  
  # directories
  Hash $directories,

  # Hearthbeat
  Hash $hearthbeat,

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
  Array[Storm::Backend::WebdavPoolMember] $info_webdav_pool_list,
  Array[Storm::Backend::SrmPoolMember] $info_frontend_host_list,

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
