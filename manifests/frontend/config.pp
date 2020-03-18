# @summary StoRM Frontend config class
#
class storm::frontend::config (

  $user_name = $storm::frontend::user_name,
  $user_uid = $storm::frontend::user_uid,
  $user_gid = $storm::frontend::user_gid,

  $db_host = $storm::frontend::db_host,
  $db_user = $storm::frontend::db_user,
  $db_passwd = $storm::frontend::db_passwd,

  $config_dir = $storm::frontend::config_dir,
  $hostcert_dir = $storm::frontend::hostcert_dir,

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

  # storm user's group
  group { $user_name:
    ensure => present,
    gid    => $user_gid,
  }

  # storm user
  user { $user_name:
    ensure  => present,
    uid     => $user_uid,
    gid     => $user_name,
    require => Group[$user_name],
  }

  # set ownership and permissions on storm fe config dir
  file { 'fe::storm-fe-config-dir':
    ensure  => directory,
    path    => $config_dir,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0750',
    recurse => true,
    require => User[$user_name],
  }

  file { 'fe::hostcert-dir':
    ensure  => directory,
    path    => $hostcert_dir,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0755',
    recurse => true,
  }

  storm::service_hostcert { 'fe::host-credentials':
    hostcert => "${hostcert_dir}/hostcert.pem",
    hostkey  => "${hostcert_dir}/hostkey.pem",
    owner    => $user_name,
    group    => $user_name,
    require  => File['fe::hostcert-dir'],
  }

  $conf_file="${config_dir}/storm-frontend-server.conf"
  $conf_template_file='storm/etc/storm/frontend-server/storm-frontend-server.conf.erb'

  file { 'fe::configure-fe-conf-file':
    ensure  => present,
    path    => $conf_file,
    content => template($conf_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-server'],
  }

  case $::os['architecture'] {

    'x86_64': {
      $ld_library_path='/usr/lib64/storm'
    }
    # In any other case:
    default: {
      $ld_library_path='/usr/lib/storm'
    }
  }

  $sysconfig_file='/etc/sysconfig/storm-frontend-server'
  $sysconfig_template_file='storm/etc/sysconfig/storm-frontend-server.erb'
  file { 'fe::configure-sysconfig-file':
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-server'],
  }
}
