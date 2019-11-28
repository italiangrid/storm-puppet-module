# @summary StoRM Backend config class
#
class storm::backend::config (

  $user_name = $storm::backend::user_name,
  $config_dir = $storm::backend::config_dir,

  $storage_areas = $storm::backend::storage_areas,

) {

  # set ownership and permissions on storm be config dir
  file { 'be::storm-be-config-dir':
    ensure  => directory,
    path    => $config_dir,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  $namespace_file="${config_dir}/namespace.xml"
  $namespace_template_file='storm/etc/storm/backend-server/namespace.xml.erb'

  file { 'be::configure-be-namespace-file':
    ensure  => present,
    path    => $namespace_file,
    content => template($namespace_template_file),
    notify  => Service['storm-backend-server'],
    require => Package['storm-backend-server-mp'],
  }
}
