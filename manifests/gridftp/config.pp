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
) {

  $conf_file='/etc/gridftp.conf'
  $conf_template_file='storm/etc/gridftp.conf.erb'

  file { 'gftp::configure-gridftp-conf-file':
    ensure  => present,
    path    => $conf_file,
    content => template($conf_template_file),
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-server'],
  }

  $sysconfig_file='/etc/sysconfig/storm-globus-gridftp'
  $sysconfig_template_file='storm/etc/sysconfig/storm-globus-gridftp.erb'

  file { 'gftp::configure-gridftp-sysconfig-file':
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-server'],
  }
}
