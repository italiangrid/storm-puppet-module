# @summary StoRM GridFTP config class
#
class storm::gridftp::config (

  $port = $storm::gridftp::port,
  $port_range = $storm::gridftp::port_range,
  $connections_max = $storm::gridftp::connections_max,

  $log_single = $storm::gridftp::log_single,
  $log_transfer = $storm::gridftp::log_transfer,

  $redirect_lcmaps_log = $storm::gridftp::redirect_lcmaps_log,
  $llgt_log_file = $storm::gridftp::llgt_log_file,

  $lcmaps_debug_level = $storm::gridftp::lcmaps_debug_level,
  $lcas_debug_level = $storm::gridftp::lcas_debug_level,

  $load_storm_dsi_module = $storm::gridftp::load_storm_dsi_module,
) {

  $conf_file='/etc/gridftp.conf'
  $conf_template_file='storm/etc/gridftp.conf.erb'

  file { $conf_file:
    ensure  => present,
    content => template($conf_template_file),
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-mp'],
  }

  $sysconfig_file='/etc/sysconfig/storm-globus-gridftp'
  $sysconfig_template_file='storm/etc/sysconfig/storm-globus-gridftp.erb'

  file { $sysconfig_file:
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-mp'],
  }

  file { '/etc/grid-security/gsi-authz.conf':
    ensure  => present,
    source  => 'puppet:///modules/storm/etc/grid-security/gsi-authz.conf',
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-mp'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/lcmaps/lcmaps.db':
    ensure => present,
    source => 'puppet:///modules/storm/etc/lcmaps/lcmaps.db',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Service['storm-globus-gridftp'],
  }

  file { '/etc/lcas/lcas.db':
    ensure => present,
    source => 'puppet:///modules/storm/etc/lcas/lcas.db',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Service['storm-globus-gridftp'],
  }

  file { '/etc/lcas/ban_users.db':
    ensure => present,
    source => 'puppet:///modules/storm/etc/lcas/ban_users.db',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Service['storm-globus-gridftp'],
  }
}
