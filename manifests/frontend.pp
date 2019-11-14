# @!puppet.type.param
# @summary StoRM Frontend puppet module
#
# Parameters
# ----------
# 
# The StoRM Frontend configuration parameters are:
#
# * `name`: description
# 
# @example Example of usage
#    class { 'storm::frontend':
#    }
#
# @param name
#   Description
#
class storm::frontend (

  String $user_name = $storm::frontend::params::user_name,

  String $db_host = $storm::frontend::params::db_host,
  String $db_user = $storm::frontend::params::db_user,
  String $db_passwd = $storm::frontend::params::db_passwd,

  String $config_dir = $storm::frontend::params::config_dir,

  Integer $port = $storm::frontend::params::port,
  Integer $threadpool_threads_number = $storm::frontend::params::threadpool_threads_number,
  Integer $gsoap_maxpending = $storm::frontend::params::gsoap_maxpending,

  String $be_xmlrpc_host = $storm::frontend::params::be_xmlrpc_host,
  String $be_xmlrpc_token = $storm::frontend::params::be_xmlrpc_token,
  Integer $be_xmlrpc_port = $storm::frontend::params::be_xmlrpc_port,
  String $be_xmlrpc_path = $storm::frontend::params::be_xmlrpc_path,

  Integer $be_recalltable_port = $storm::frontend::params::be_recalltable_port,

  Boolean $check_user_blacklisting = $storm::frontend::params::check_user_blacklisting,
  String $argus_pepd_endpoint = $storm::frontend::params::argus_pepd_endpoint,

  Boolean $monitoring_enabled = $storm::frontend::params::monitoring_enabled,
  Integer $monitoring_time_interval = $storm::frontend::params::monitoring_time_interval,
  Boolean $monitoring_detailed = $storm::frontend::params::monitoring_detailed,

  Boolean $security_enable_vomscheck = $storm::frontend::params::security_enable_vomscheck,

  String $log_debuglevel = $storm::frontend::params::log_debuglevel,

) inherits storm::frontend::params {

  contain storm::frontend::install
  contain storm::frontend::config
  contain storm::frontend::service

  Class['storm::frontend::install']
  -> Class['storm::frontend::config']
  -> Class['storm::frontend::service']
}
