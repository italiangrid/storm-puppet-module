# @summary StoRM Backend config class
#
class storm::backend::config (

) {

  # Service's host credentials directory
  if !defined(File['/etc/grid-security/storm']) {
    file { '/etc/grid-security/storm':
      ensure  => directory,
      owner   => 'storm',
      group   => 'storm',
      mode    => '0755',
      recurse => true,
    }
    # Service's hostcert
    file { '/etc/grid-security/storm/hostcert.pem':
      ensure  => present,
      mode    => '0644',
      owner   => 'storm',
      group   => 'storm',
      source  => '/etc/grid-security/hostcert.pem',
      require => File['/etc/grid-security/storm'],
    }
    # Service's hostkey
    file { '/etc/grid-security/storm/hostkey.pem':
      ensure  => present,
      mode    => '0400',
      owner   => 'storm',
      group   => 'storm',
      source  => '/etc/grid-security/hostkey.pem',
      require => File['/etc/grid-security/storm'],
    }
  }

  $namespace_file='/etc/storm/backend-server/namespace.xml'
  $namespace_template_file='storm/etc/storm/backend-server/namespace.xml.erb'

  file { $namespace_file:
    ensure  => present,
    content => template($namespace_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => [Service['storm-backend-server']],
  }

  # Starting from Puppet module v4.0.0, the management of storm.properties
  # file has been changed from providing a long list of parameters to a provided
  # external file. Administrators have to provide their own storm.properties file
  # that is more maintainable through different puppet module versions.
  $properties_file='/etc/storm/backend-server/storm.properties'
  if !empty($storm::backend::storm_properties_file) {
    notice("${properties_file} initialized from ${storm::backend::storm_properties_file}")
    # init storm.properties from source
    file { $properties_file:
      ensure => present,
      source => $storm::backend::storm_properties_file,
      owner  => 'root',
      group  => 'storm',
      notify => [Service['storm-backend-server']],
    }
  } else {
    notice("${properties_file} initialized from internal template")
    # use internal template, updated to the last released 
    $properties_template_file='storm/etc/storm/backend-server/storm.properties.erb'
    file { $properties_file:
      ensure  => present,
      content => template($properties_template_file),
      owner   => 'root',
      group   => 'storm',
      notify  => [Service['storm-backend-server']],
    }
  }

  # Directory '/etc/systemd/system/storm-backend-server.service.d' is created by rpm
  $service_dir='/etc/systemd/system/storm-backend-server.service.d'

  # service conf file
  $service_file="${service_dir}/storm-backend-server.conf"
  $service_template_file='storm/etc/systemd/system/storm-backend-server.service.d/storm-backend-server.conf.erb'

  file { $service_file:
    ensure  => present,
    content => template($service_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => [Service['storm-backend-server']],
  }

  # limit conf file
  $limit_file="${service_dir}/filelimit.conf"
  $limit_template_file='storm/etc/systemd/system/storm-backend-server.service.d/filelimit.conf.erb'

  file { $limit_file:
    ensure  => present,
    content => template($limit_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => [Service['storm-backend-server']],
  }

  $info_yaim_template_file='storm/etc/storm/info-provider/storm-yaim-variables.conf.erb'
  $info_backend_host=$::fqdn
  $info_frontend_host=$storm::backend::srm_pool_members[0]['hostname']
  if ($storm::backend::srm_pool_members[0]['port']) {
    $info_frontend_port=$storm::backend::srm_pool_members[0]['port']
  } else {
    $info_frontend_port=8444
  }
  file { $storm::backend::info_config_file:
    ensure  => present,
    content => template($info_yaim_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'storm',
    notify  => [Exec['configure-info-provider']],
  }

  if !empty($storm::backend::path_authz_db_file) {
    # StoRM Backend's path-authz.db file
    file { '/etc/storm/backend-server/path-authz.db':
      ensure => present,
      mode   => '0644',
      owner  => 'root',
      group  => 'storm',
      source => $storm::backend::path_authz_db_file,
      notify => [Service['storm-backend-server']],
    }
  }
}
