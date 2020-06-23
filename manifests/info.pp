# @summary StoRM Info Provider class
#
# @param example
#   Description of example param
#
class storm::info (

  String $backend_hostname = $storm::info::params::backend_hostname,
  String $frontend_public_host = $storm::info::params::frontend_public_host,

  String $sitename = $storm::info::params::sitename,
  Array[Storm::Backend::StorageArea] $storage_areas = $storm::info::params::storage_areas,
  String $storage_default_root = $storm::info::params::storage_default_root,
  String $frontend_path = $storm::info::params::frontend_path,
  Integer $frontend_port = $storm::info::params::frontend_port,
  Integer $rest_services_port = $storm::info::params::rest_services_port,
  Integer $endpoint_quality_level = $storm::info::params::endpoint_quality_level,
  Array[Storm::Backend::WebdavPoolMember] $webdav_pool_members = $storm::info::params::webdav_pool_members,
  Array[Storm::Backend::SrmPoolMember] $srm_pool_members = $storm::info::params::srm_pool_members,

  String $config_file = $storm::info::params::config_file,

) inherits storm::info::params {

  contain storm::info::install
  contain storm::info::config

  Class['storm::info::install']
  -> Class['storm::info::config']

}
