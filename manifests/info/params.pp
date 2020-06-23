# @summary StoRM Info params class
#
class storm::info::params (

) inherits storm::params {

  $config_file = lookup('storm::info::config_file', String, undef, '/etc/storm/info-provider/storm-yaim-variables.conf')

  $sitename = lookup('storm::info::sitename', String, undef, 'StoRM')
  $backend_hostname =lookup('storm::info::backend_hostname', String, undef, 'backend.example.org')
  $storage_default_root = lookup('storm::info::storage_default_root', String, undef, '/storage')
  $storage_areas = lookup('storm::info::storage_areas', Array[Storm::Backend::StorageArea], undef, [])
  $frontend_public_host =lookup('storm::info::frontend_public_host', String, undef, 'frontend.example.org')
  $frontend_path = lookup('storm::info::frontend_path', String, undef, '/srm/managerv2')
  $frontend_port = lookup('storm::info::frontend_port', Integer, undef, 8444)
  $rest_services_port = lookup('storm::info::rest_services_port', Integer, undef, 9998)
  $endpoint_quality_level = lookup('storm::info::endpoint_quality_level', Integer, undef, 2)
  $webdav_pool_members = lookup('storm::info::webdav_pool_members', Array[Storm::Backend::WebdavPoolMember], undef, [])
  $srm_pool_members = lookup('storm::info::srm_pool_members', Array[Storm::Backend::SrmPoolMember], undef, [])
}
