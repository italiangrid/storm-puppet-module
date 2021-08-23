# @summary StoRM Frontend config class
#
class storm::frontend::config (

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

  $conf_file='/etc/storm/frontend-server/storm-frontend-server.conf'

  if (!empty($storm::frontend::configuration_file)) {
    notice("${conf_file} initialized from ${storm::frontend::configuration_file}")
    file { $conf_file:
      ensure  => present,
      owner   => 'root',
      group   => 'storm',
      source  => $storm::frontend::configuration_file,
      notify  => Service['storm-frontend-server'],
      require => Package['storm-frontend-mp'],
    }
  } else {
    notice("${conf_file} initialized from internal template")
    $conf_template_file='storm/etc/storm/frontend-server/storm-frontend-server.conf.erb'
    file { $conf_file:
      ensure  => present,
      owner   => 'root',
      group   => 'storm',
      content => template($conf_template_file),
      notify  => Service['storm-frontend-server'],
      require => Package['storm-frontend-mp'],
    }
  }

  $ld_library_path=$::os['architecture'] ? {
    'x86_64' => '/usr/lib64/storm',
    default  => '/usr/lib/storm',
  }

  $sysconfig_file='/etc/sysconfig/storm-frontend-server'
  $sysconfig_template_file='storm/etc/sysconfig/storm-frontend-server.erb'
  file { $sysconfig_file:
    ensure  => present,
    content => template($sysconfig_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-mp'],
  }
}
