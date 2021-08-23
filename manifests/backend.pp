# @!puppet.type.param
# @summary StoRM Backend installation and configuration class.
#
# It's recommended to set your own database password and XMLRPC security token.
# You also mainly need to configure your storage areas and the list of SRM, GridFTP and (in case) WebDAV endpoints.
#
# @example Example of usage
#    class { 'storm::backend':
#      db_password => 'my-secret-db-password',
#      xmlrpc_security_token => 'my-secret-xmlrpc-token',
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
#      transfer_protocols => ['file', 'gsiftp', 'webdav'],
#      storage_areas => [
#        {
#          'name'               => 'test.vo',
#          'root_path'          => '/storage/test.vo',
#          'access_points'      => ['/test.vo'],
#          'vos'                => ['test.vo'],
#          'storage_class'      => 'T0D1',
#          'online_size'        => 4,
#        },
#      ],
#    }
#
# @example Example with a provided 'storm.properties'
#    class { 'storm::backend':
#      db_password => 'my-secret-db-password',
#      storm_properties_file => '/path/to/your/storm.properties',
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
#      transfer_protocols => ['file', 'gsiftp', 'webdav'],
#      storage_areas => [
#        {
#          'name'               => 'test.vo',
#          'root_path'          => '/storage/test.vo',
#          'access_points'      => ['/test.vo'],
#          'vos'                => ['test.vo'],
#          'storage_class'      => 'T0D1',
#          'online_size'        => 4,
#        },
#      ],
#    }
#
# @param storm_properties_file Use this to provide your own storm.properties file. This can be used for example when you're using
#   the latest module version to configure an old StoRM deployment. It's used when it has a non-empty value, and it overwrites several
#   other module parameters. Default value: empty string.
#
# @param hostname StoRM Backend Fully Qualified Domain Name.
#
# @param db_username The connection user name to be passed to the JDBC driver to establish a connection. Default value: 'storm'.
#
# @param db_password The connection password to be passed to the JDBC driver to establish a connection. Default value: 'storm'.
#
# @param db_hostname Fully Qualified Domain Name of database hostname.
#
# @param db_port Database connection URL port. Ignored if `storm_properties_file` is set. Default value: 3306.
#
# @param db_properties The connection properties that will be sent to the JDBC driver when establishing new connections.
#   Format of the string must be [propertyName=property;]*
#   NOTE - The "user" and "password" properties will be passed explicitly, so they do not need to be included here.
#   Ignored if `storm_properties_file` is set. Default value: 'serverTimezone=UTC&autoReconnect=true'
#
# @param db_pool_size The maximum number of active connections that can be allocated from database connection pool at the same time,
#   or negative for no limit. Ignored if `storm_properties_file` is set. Default value: -1.
#
# @param db_pool_min_idle The minimum number of connections that can remain idle in the pool, without extra ones being created, or zero
#   to create none. Ignored if `storm_properties_file` is set. Default value: 10.
#
# @param db_pool_max_wait_millis The maximum number of milliseconds that the pool will wait (when there are no available connections)
#   for a connection to be returned before throwing an exception, or -1 to wait indefinitely. Default value: 5000.
#
# @param db_pool_test_on_borrow The indication of whether objects will be validated before being borrowed from the pool. If the
#   object fails to validate, it will be dropped from the pool, and we will attempt to borrow another. Default value: true.
#
# @param db_pool_test_while_idle The indication of whether objects will be validated by the idle object evictor (if any). If an object
#   fails to validate, it will be dropped from the pool. Default value: true.
#
# @param srm_public_host StoRM Frontend/SRM service public host. It’s used by StoRM Info Provider to publish the SRM endpoint into the
#   Resource BDII.
#
# @param srm_public_port StoRM Frontend/SRM service public port. Default value: 8444.
#
# @param rest_services_port Internal REST services endpoint port. Ignored if `storm_properties_file` is set.
#   Default value: 9998.
#
# @param rest_services_max_threads Internal REST services endpoint max active requests.
#   Ignored if `storm_properties_file` is set. Default value: 100.
#
# @param rest_services_max_queue_size Internal REST services endpoint max queue size of accepted requests.
#   Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param xmlrpc_unsecure_server_port Port to listen on for incoming XML-RPC connections from Frontends(s).
#   Ignored if `storm_properties_file` is set. Default value: 8080.
#
# @param xmlrpc_maxthread Number of threads managing XML-RPC connection from Frontends(s). A well sized value for this parameter
#   have to be at least equal to the sum of the number of working threads in all FrontEend(s). Ignored if `storm_properties_file` is set.
#   Default value: 256.
#
# @param xmlrpc_max_queue_size Max number of accepted and queued XML-RPC connection from Frontends(s).
#   Ignored if `storm_properties_file` is set. Default value: 1000.
#
# @param xmlrpc_security_enabled Whether the backend will require a token to be present for accepting XML-RPC requests.
#   Ignored if `storm_properties_file` is set. Default value: true.
#
# @param xmlrpc_security_token The token that the backend will require to be present for accepting XML-RPC requests.
#   Mandatory if `synchcall.xmlrpc.token.enabled` is true.
#   Ignored if `storm_properties_file` is set. Default value: 'secret'
#
# @param xroot_hostname If your deployment also consists of a xroot server, this is its FQDN in order to be used to provide valid
#   TURLs. Setting this parameter, the administrator provides a default value for all Storage Areas that have
#   'xroot' as a transfer protocol. Note: you may overwrite this setting at single SA configuration level.
#
# @param xroot_port Xroot server port default value for all Storage Areas that have 'xroot' as a transfer protocol.
#   Note: you may overwrite this setting at single SA configuration level.
#   Default value: 1094.
#
# @param gsiftp_pool_balance_strategy Default load balancing strategy of GridFTP server pool for all the Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level.
#   Available values: 'round-robin', 'smart-rr', 'random', 'weight'. Default value: 'round-robin'.
#
# @param gsiftp_pool_members Default GridFTP servers pool list for all Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param webdav_pool_members Default WebDAV endpoint pool list for all Storage Areas.
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param srm_pool_members Default SRM endpoint pool list for all Storage Areas (the Frontend list).
#   Note: you may overwrite this setting at single SA configuration level. Default value: empty array.
#
# @param transfer_protocols Default list of supported (and published) transfer protocols for all Storage Areas. 
#   Note: you may overwrite this setting at single SA configuration level. Default value: ['file', 'gsiftp']
#
# @param fs_type Default File System Type value for all Storage Areas. Note: you may overwrite this setting at single SA configuration
#   level. Available values: 'posixfs', 'gpfs' and 'test'. Default value: 'posixfs'
#
# @param storage_areas The list of the managed storage areas. For each storage area a proper configuration must be provided.
#   Default value: empty array.
#
# @param sanity_check_enabled Enable/disable sanity checks during bootstrap phase. Ignored if `storm_properties_file` is set. Default
#   value: true.
#
# @param service_du_enabled Flag to enable disk usage service. Ignored if `storm_properties_file` is set. 
#   Default value: false.
#
# @param service_du_delay The initial delay before the service is started (seconds). Ignored if `storm_properties_file` is set.
#   Default value: 60.
#
# @param service_du_interval The interval in seconds between successive run. Ignored if `storm_properties_file` is set.
#   Default value: 360.
#
# @param advanced_properties Here you can specify additional configuration parameters for storm.properties. Each key will be added
#   with its value into your configuration file.
#
# @param info_config_file Path of the Info Provider main configuration file auto-generated.
#
# @param info_sitename It’s the human-readable name of your site used to set the Glue-SiteName attribute.
#   Default value: 'StoRM site'.
#
# @param info_storage_default_root Default directory for Storage Areas.
#
# @param info_endpoint_quality_level Endpoint maturity level to be published by the StoRM info provider. Default value: 2.
#
# @param info_webdav_pool_list List of published WebDAV endpoints.
#
# @param info_frontend_host_list List of published SRM endpoints.
#
# @param jvm_options Default value: '-Xms512m -Xmx512m'
#
# @param lcmaps_db_file Default value: '/etc/storm/backend-server/lcmaps.db'.
#
# @param lcmaps_policy_name Default value: 'standard'.
#
# @param lcmaps_log_file Default value: '/var/log/storm/lcmaps.log'.
#
# @param lcmaps_debug_level Default value: 0.
#
# @param storm_limit_nofile Sets LimitNOFILE value. Default value: 65535.
#
# @param path_authz_db_file If not an empty string, set the content of your path-authz.db file from this source path.
#   Default value: empty string.
#
class storm::backend (

  # Manage storm.properties
  String $storm_properties_file,

  # Db connection
  String $db_username,
  String $db_password,
  Integer $db_port,
  String $db_properties,

  # Db pool
  Integer $db_pool_size,
  Integer $db_pool_min_idle,
  Integer $db_pool_max_wait_millis,
  Boolean $db_pool_test_on_borrow,
  Boolean $db_pool_test_while_idle,

  # SRM public endpoint
  Integer $srm_public_port,

  # REST server conf
  Integer $rest_services_port,
  Integer $rest_services_max_threads,
  Integer $rest_services_max_queue_size,

  # XMLRPC Server parameter
  Integer $xmlrpc_server_port,
  Integer $xmlrpc_max_threads,
  Integer $xmlrpc_max_queue_size,
  Boolean $xmlrpc_security_enabled,
  String $xmlrpc_security_token,

  ### Default values for Storage Areas
  # 1. xroot
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

  # Sanity checks
  Boolean $sanity_check_enabled,

  # DU service
  Boolean $du_service_enabled,
  Integer $du_service_initial_delay,
  Integer $du_service_tasks_interval,
  Boolean $du_service_parallel_tasks_enabled,

  # Advanced storm.properties
  Hash $advanced_properties,

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

  # hostnames
  String $hostname = $::fqdn,
  String $srm_public_host = $hostname,
  String $db_hostname = $hostname,
  String $xroot_hostname = $hostname,

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
