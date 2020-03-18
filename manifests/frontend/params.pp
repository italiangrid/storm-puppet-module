# @summary StoRM Frontend params class
#
class storm::frontend::params (
) inherits storm::params {

  $user_name = $storm::params::user_name
  $user_uid = $storm::params::user_uid
  $user_gid = $storm::params::user_gid

  $db_host = $storm::params::db_host
  $db_user = $storm::params::db_user
  $db_passwd = $storm::params::db_passwd

  $config_dir = lookup('storm::frontend::config_dir', String, undef, '/etc/storm/frontend-server')
  $hostcert_dir = lookup('storm::frontend::hostcert_dir', String, undef, '/etc/grid-security/storm')

  $port = lookup('storm::frontend::port', Integer, undef, 8444)
  $threadpool_threads_number = lookup('storm::frontend::threadpool_threads_number', Integer, undef, 50)
  $threadpool_maxpending = lookup('storm::frontend::threadpool.maxpending', Integer, undef, 200)
  $gsoap_maxpending = lookup('storm::frontend::gsoap_maxpending', Integer, undef, 1000)

  $be_xmlrpc_host = lookup('storm::frontend::be_xmlrpc_host', String, undef, 'localhost')
  $be_xmlrpc_token = lookup('storm::frontend::be_xmlrpc_token', String, undef, 'token')
  $be_xmlrpc_port = lookup('storm::frontend::be_xmlrpc_port', Integer, undef, 8080)
  $be_xmlrpc_path = lookup('storm::frontend::be_xmlrpc_path', String, undef, '/RPC2')

  $be_recalltable_port = lookup('storm::frontend::be_recalltable_port', Integer, undef, 9998)

  $check_user_blacklisting = lookup('storm::frontend::check_user_blacklisting', Boolean, undef, false)
  $argus_pepd_endpoint = lookup('storm::frontend::argus_pepd_endpoint', String, undef, '')

  $monitoring_enabled = lookup('storm::frontend::monitoring_enabled', Boolean, undef, true)
  $monitoring_time_interval = lookup('storm::frontend::monitoring_time_interval', Integer, undef, 60)
  $monitoring_detailed = lookup('storm::frontend::monitoring_detailed', Boolean, undef, false)

  $security_enable_mapping = lookup('storm::frontend::security_enable_mapping', Boolean, undef, false)
  $security_enable_vomscheck = lookup('storm::frontend::security_enable_vomscheck', Boolean, undef, true)

  $log_debuglevel = lookup('storm::frontend::log_debuglevel', String, undef, 'INFO')

  $gridmap_dir = lookup('storm::frontend::gridmap_dir', String, undef, '/etc/grid-security/gridmapdir')
  $gridmap_file = lookup('storm::frontend::gridmap_file', String, undef, '/etc/grid-security/grid-mapfile')

}
