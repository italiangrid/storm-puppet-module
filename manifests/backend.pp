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

  String $user_name = $storm::backend::params::user_name,

  String $db_host = $storm::backend::params::db_host,
  String $db_user = $storm::backend::params::db_user,
  String $db_passwd = $storm::backend::params::db_passwd,

  String $config_dir = $storm::backend::params::config_dir,

  String $rfio_hostname = lookup('storm::backend::rfio_hostname', String, undef, $hostname),
  Integer $rfio_port = $storm::backend::params::rfio_port,

  String $xroot_hostname = lookup('storm::backend::xroot_hostname', String, undef, $hostname),
  Integer $xroot_port = $storm::backend::params::xroot_port,

  Storm::Backend::BalanceStrategy $gsiftp_pool_balance_strategy = $storm::backend::params::gsiftp_pool_balance_strategy,
  Array[Storm::Backend::GsiftpPoolMember] $gsiftp_pool_members = $storm::backend::params::gsiftp_pool_members,
  Array[Storm::Backend::WebdavPoolMember] $webdav_pool_members = $storm::backend::params::webdav_pool_members,

  Array[Storm::Backend::StorageArea] $storage_areas = $storm::backend::params::storage_areas,

  String $frontend_public_host = lookup('storm::backend::srm_hostname', String, undef, $hostname)

) inherits storm::backend::params {

  contain storm::backend::install
  contain storm::backend::config
  contain storm::backend::service

  Class['storm::backend::install']
  -> Class['storm::backend::config']
  -> Class['storm::backend::service']
}
