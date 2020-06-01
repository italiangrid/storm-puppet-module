# @!puppet.type.param
# @summary StoRM Backend puppet module
#
# Parameters
# ----------
# 
# The StoRM Backend configuration parameters are:
#
# * `name`: description
# 
# @example Example of usage
#    class { 'storm::backend':
#    }
#
# @param name
#   Description
#
class storm::backend (

  String $hostname,

  String $db_host = lookup('storm::backend::db_host', String, undef, $hostname),
  String $db_user = $storm::backend::params::db_user,
  String $db_passwd = $storm::backend::params::db_passwd,

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

) inherits storm::backend::params {

  contain storm::backend::install
  contain storm::backend::config
  contain storm::backend::service

  Class['storm::backend::install']
  -> Class['storm::backend::config']
  -> Class['storm::backend::service']
}
