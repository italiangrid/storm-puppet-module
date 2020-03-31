# @summary StoRM Frontend config class
#
class storm::frontend::config (

  $db_host = $storm::frontend::db_host,
  $db_user = $storm::frontend::db_user,
  $db_passwd = $storm::frontend::db_passwd,

  $port = $storm::frontend::port,

  $threadpool_threads_number = $storm::frontend::threadpool_threads_number,
  $threadpool_maxpending = $storm::frontend::threadpool_maxpending,
  $gsoap_maxpending = $storm::frontend::gsoap_maxpending,

  $be_xmlrpc_host = $storm::frontend::be_xmlrpc_host,
  $be_xmlrpc_token = $storm::frontend::be_xmlrpc_token,
  $be_xmlrpc_port = $storm::frontend::be_xmlrpc_port,
  $be_xmlrpc_path = $storm::frontend::be_xmlrpc_path,

  $be_recalltable_port = $storm::frontend::be_recalltable_port,

  $check_user_blacklisting = $storm::frontend::check_user_blacklisting,
  $argus_pepd_endpoint = $storm::frontend::argus_pepd_endpoint,

  $monitoring_enabled = $storm::frontend::monitoring_enabled,
  $monitoring_time_interval = $storm::frontend::monitoring_time_interval,
  $monitoring_detailed = $storm::frontend::monitoring_detailed,

  $security_enable_mapping = $storm::frontend::security_enable_mapping,
  $security_enable_vomscheck = $storm::frontend::security_enable_vomscheck,

  $log_debuglevel = $storm::frontend::log_debuglevel,

  $gridmap_dir = $storm::frontend::gridmap_dir,
  $gridmap_file = $storm::frontend::gridmap_file,

) {

  # Service's host credentials directory
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

  $conf_file='/etc/storm/frontend-server/storm-frontend-server.conf'
  $conf_template_file='storm/etc/storm/frontend-server/storm-frontend-server.conf.erb'

  file { $conf_file:
    ensure  => present,
    owner   => 'root',
    group   => 'storm',
    content => template($conf_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-mp'],
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
