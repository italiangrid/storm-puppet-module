#
class storm::info::config (

  $sitename = $storm::info::sitename,
  $backend_hostname = $storm::info::backend_hostname,
  $storage_areas = $storm::info::storage_areas,
  $config_file = $storm::info::config_file,
  $storage_default_root = $storm::info::storage_default_root,
  $frontend_public_host = $storm::info::frontend_public_host,
  $frontend_path = $storm::info::frontend_path,
  $frontend_port = $storm::info::frontend_port,
  $rest_services_port = $storm::info::rest_services_port,
  $endpoint_quality_level = $storm::info::endpoint_quality_level,
  $webdav_pool_members = $storm::info::webdav_pool_members,
  $srm_pool_members = $storm::info::srm_pool_members,
  $transfer_protocols = $storm::info::transfer_protocols,

) {

  $info_yaim_template_file='storm/etc/storm/info-provider/storm-yaim-variables.conf.erb'

  file { $config_file:
    ensure  => present,
    content => template($info_yaim_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => Exec['configure-info-provider'],
    require => [Package['storm-dynamic-info-provider']],
  }

  exec { 'configure-info-provider':
    command     => '/usr/libexec/storm-info-provider configure',
    unless      => '/bin/rpm -q storm-dynamic-info-provider',
    refreshonly => true,
    require     => [File[$config_file]],
  }

}
