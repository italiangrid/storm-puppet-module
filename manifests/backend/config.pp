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
      ensure  => file,
      mode    => '0644',
      owner   => 'storm',
      group   => 'storm',
      source  => '/etc/grid-security/hostcert.pem',
      require => File['/etc/grid-security/storm'],
    }
    # Service's hostkey
    file { '/etc/grid-security/storm/hostkey.pem':
      ensure  => file,
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
    ensure  => file,
    content => template($namespace_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => [Service['storm-backend-server']],
  }

  $properties_file='/etc/storm/backend-server/storm.properties'
  if $storm::backend::manage_storm_properties {
    file { $properties_file:
      ensure => file,
      source => $storm::backend::path_storm_properties,
      owner  => 'root',
      group  => 'storm',
      notify => [Service['storm-backend-server']],
    }
  } else {
    $properties_template_file='storm/etc/storm/backend-server/storm.properties.erb'
    file { $properties_file:
      ensure  => file,
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
    ensure  => file,
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
    ensure  => file,
    content => template($limit_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => [Service['storm-backend-server']],
  }

  $info_yaim_template_file='storm/etc/storm/info-provider/storm-yaim-variables.conf.erb'

  file { $storm::backend::info_config_file:
    ensure  => file,
    content => template($info_yaim_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'storm',
    notify  => [Exec['configure-info-provider']],
  }

  if $storm::backend::manage_path_authz_db {
    # StoRM Backend's path-authz.db file
    file { '/etc/storm/backend-server/path-authz.db':
      ensure => file,
      mode   => '0644',
      owner  => 'root',
      group  => 'storm',
      source => $storm::backend::path_authz_db_file,
      notify => [Service['storm-backend-server']],
    }
  }
}
