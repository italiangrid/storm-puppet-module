# @!puppet.type.param
# @summary StoRM Frontend puppet module
#
# @example Example of usage
#    class { 'storm::frontend':
#      be_xmlrpc_host  => 'storm-backend.example',
#      be_xmlrpc_token => 'secret',
#      db_host         => 'storm-backend.example',
#      db_user         => 'storm',
#      db_passwd       => 'secret',
#    }
#
# @param be_xmlrpc_host
#   Backend hostname. Required.
#
# @param be_xmlrpc_port
#   Backend XML-RPC server port. Default is 8080.
#
# @param be_xmlrpc_token
#   Token used for communicating with Backend service. Mandatory, has no default.
#
# @param be_xmlrpc_path
#   XML-RPC server path. Default is /RPC2.
#
# @param be_recalltable_port
#   REST server port running on the Backend machine. Default is 9998.
#
# @param db_host
#   Host for database connection. Default is set to be_xmlrpc_host.
#
# @param db_user
#   User for database connection. Default is storm.
#
# @param db_passwd
#   Password for database connection. Default is storm.
#
# @param port
#   Frontend service port. Default is 8444.
#
# @param threadpool_maxpending
#   Size of the internal queue used to maintain SRM tasks in case there are no free worker threads. Default is 200
#
# @param threadpool_threads_number
#   Size of the worker thread pool. Default is 50.
#
# @param gsoap_maxpending
#   Size of the GSOAP queue used to maintain pending SRM requests. Default is 1000.
#
# @param check_user_blacklisting
#   Enable/disable user blacklisting. Default is false.
#
# @param argus_pepd_endpoint
#   The complete service endpoint of Argus PEP server. Mandatory if check_user_blacklisting is true.
#
# @param monitoring_enabled
#   Enable/disable monitoring. Default is true.
#
# @param monitoring_time_interval
#   Time interval in seconds between each monitoring round. Default is 60.
#
# @param monitoring_detailed
#   Enable/disable detailed monitoring. Default is false.
#
# @param security_enable_mapping
#   Flag to enable/disable DN-to-userid mapping via gridmap-file. Default is false.
#
# @param security_enable_vomscheck
#   Flag to enable/disable checking proxy VOMS credentials. Default is true.
#
# @param log_debuglevel
#   Logging level. Possible values are: ERROR, WARN, INFO, DEBUG, DEBUG2. Default is INFO
#
# @param gridmap_dir
#   Gridmap directory path. Defailt value is: /etc/grid-security/gridmapdir
#
# @param gridmap_file
#   Gridmap file path. Defailt value is: /etc/grid-security/grid-mapfile
#
class storm::frontend (

  String $be_xmlrpc_host,
  String $be_xmlrpc_token = $storm::frontend::params::be_xmlrpc_token,
  Integer $be_xmlrpc_port = $storm::frontend::params::be_xmlrpc_port,
  String $be_xmlrpc_path = $storm::frontend::params::be_xmlrpc_path,
  Integer $be_recalltable_port = $storm::frontend::params::be_recalltable_port,

  String $db_host = lookup('storm::frontend::db::host', String, undef, $be_xmlrpc_host),
  String $db_user = $storm::frontend::params::db_user,
  String $db_passwd = $storm::frontend::params::db_passwd,

  Integer $port = $storm::frontend::params::port,
  Integer $threadpool_threads_number = $storm::frontend::params::threadpool_threads_number,
  Integer $threadpool_maxpending = $storm::frontend::params::threadpool_maxpending,
  Integer $gsoap_maxpending = $storm::frontend::params::gsoap_maxpending,

  Boolean $check_user_blacklisting = $storm::frontend::params::check_user_blacklisting,
  String $argus_pepd_endpoint = $storm::frontend::params::argus_pepd_endpoint,

  Boolean $monitoring_enabled = $storm::frontend::params::monitoring_enabled,
  Integer $monitoring_time_interval = $storm::frontend::params::monitoring_time_interval,
  Boolean $monitoring_detailed = $storm::frontend::params::monitoring_detailed,

  Boolean $security_enable_mapping = $storm::frontend::params::security_enable_mapping,
  Boolean $security_enable_vomscheck = $storm::frontend::params::security_enable_vomscheck,

  String $log_debuglevel = $storm::frontend::params::log_debuglevel,

  String $gridmap_dir = $storm::frontend::params::gridmap_dir,
  String $gridmap_file = $storm::frontend::params::gridmap_file,

) inherits storm::frontend::params {

  contain storm::frontend::install
  contain storm::frontend::config
  contain storm::frontend::service

  Class['storm::frontend::install']
  -> Class['storm::frontend::config']
  -> Class['storm::frontend::service']
}
