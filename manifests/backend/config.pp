# @summary StoRM Backend config class
#
class storm::backend::config (

  $db_user = $storm::backend::db_user,
  $db_passwd = $storm::backend::db_passwd,

  $storage_areas = $storm::backend::storage_areas,
  $gsiftp_pool_members = $storm::backend::gsiftp_pool_members,
  $gsiftp_pool_balance_strategy = $storm::backend::gsiftp_pool_balance_strategy,
  $webdav_pool_members = $storm::backend::webdav_pool_members,
  $srm_pool_members = $storm::backend::srm_pool_members,
  $rfio_hostname = $storm::backend::rfio_hostname,
  $rfio_port = $storm::backend::rfio_port,
  $xroot_hostname = $storm::backend::xroot_hostname,
  $xroot_port = $storm::backend::xroot_port,
  $srm_hostname = $storm::backend::frontend_public_host,

) {

  # set ownership and permissions on storm be config dir
  file { '/etc/storm/backend-server':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
  }

  $namespace_file='/etc/storm/backend-server/namespace.xml'
  $namespace_template_file='storm/etc/storm/backend-server/namespace.xml.erb'

  file { $namespace_file:
    ensure  => present,
    content => template($namespace_template_file),
    notify  => Service['storm-backend-server'],
    require => [Package['storm-backend-mp'], File['/etc/storm/backend-server']],
  }

  $properties_file='/etc/storm/backend-server/storm.properties'
  $properties_template_file='storm/etc/storm/backend-server/storm.properties.erb'

  file { $properties_file:
    ensure  => present,
    content => template($properties_template_file),
    notify  => Service['storm-backend-server'],
    require => [Package['storm-backend-mp'], File['/etc/storm/backend-server']],
  }
}
