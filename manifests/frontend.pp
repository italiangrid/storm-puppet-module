# @!puppet.type.param
# @summary StoRM Frontend puppet module
#
# @example Example of usage
#    class { 'storm::frontend':
#      be_xmlrpc_host  => 'storm-backend.host.org',
#      be_xmlrpc_token => 'my-secret-xmlrpc-token',
#      db_host         => 'storm-backend.host.org',
#      db_passwd       => 'my-secret-db-password',
#    }
#
# @param be_xmlrpc_host StoRM Backend hostname.
#
# @param be_xmlrpc_port StoRM Backend XML-RPC server port. Default value: 8080.
#
# @param be_xmlrpc_token Secutiry token used for communicating with StoRM Backend. Mandatory.
#
# @param be_xmlrpc_path StoRM Backend XML-RPC server path. Default value: '/RPC2'.
#
# @param be_recalltable_port StoRM Backend REST server port running on the Backend machine. Default value: 9998.
#
# @param db_host Host for database connection.
#
# @param db_user User for database connection. Default value: 'storm'.
#
# @param db_passwd Password for database connection. Default value: 'storm'.
#
# @param port Frontend service port. Default value: 8444.
#
# @param threadpool_maxpending Size of the internal queue used to maintain SRM tasks in case there are no free worker threads.
#  Default value: 200.
#
# @param threadpool_threads_number Size of the worker thread pool. Default value: 50.
#
# @param gsoap_maxpending Size of the GSOAP queue used to maintain pending SRM requests. Default value: 1000.
#
# @param check_user_blacklisting Enable/disable user blacklisting. Default value: false.
#
# @param argus_pepd_endpoint The complete service endpoint of Argus PEP server. Mandatory if `check_user_blacklisting` is true.
#
# @param monitoring_enabled Enable/disable monitoring. Default value: true.
#
# @param monitoring_time_interval Time interval in seconds between each monitoring round. Default value: 60.
#
# @param monitoring_detailed Enable/disable detailed monitoring. Default value: false.
#
# @param security_enable_vomscheck Flag to enable/disable checking proxy VOMS credentials. Default value: true.
#
# @param log_debuglevel Logging level. Possible values are: ERROR, WARN, INFO, DEBUG, DEBUG2. Default value: INFO.
#
# @param gridmap_dir Gridmap directory path. Defailt value: '/etc/grid-security/gridmapdir'.
#
# @param gridmap_file Gridmap file path. Defailt value: '/etc/grid-security/grid-mapfile'.
#
class storm::frontend (

  String $configuration_file,

  String $be_xmlrpc_token,
  Integer $be_xmlrpc_port,
  String $be_xmlrpc_path,
  Integer $be_recalltable_port,

  String $db_user,
  String $db_passwd,

  Integer $port,
  Integer $threadpool_threads_number,
  Integer $threadpool_maxpending,
  Integer $gsoap_maxpending,

  Boolean $check_user_blacklisting,
  String $argus_pepd_endpoint,

  Boolean $monitoring_enabled,
  Integer $monitoring_time_interval,
  Boolean $monitoring_detailed,

  Boolean $security_enable_vomscheck,

  String $log_debuglevel,

  String $gridmap_dir,
  String $gridmap_file,

  String $be_xmlrpc_host = $::fqdn,
  String $db_host = $be_xmlrpc_host,

) {

  contain storm::frontend::install
  contain storm::frontend::config
  contain storm::frontend::service

  Class['storm::frontend::install']
  -> Class['storm::frontend::config']
  -> Class['storm::frontend::service']
}
