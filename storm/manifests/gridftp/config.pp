# @summary StoRM GridFTP config class
#
class storm::gridftp::config (

  $gridftp_with_dsi = $storm::gridftp::gridftp_with_dsi,

  $tcp_port_range_min = $storm::gridftp::tcp_port_range_min,
  $tcp_port_range_max = $storm::gridftp::tcp_port_range_max,

  $connections_max = $storm::gridftp::connections_max,

) {

  $profiled_script='/etc/profile.d/storm-globus-gridftp.sh'
  $profiled_script_template_file='storm/etc/profile.d/storm-globus-gridftp.sh.erb'

  file { 'gftp::configure-profiled-file':
    ensure  => present,
    path    => $profiled_script,
    content => template($profiled_script_template_file),
  }

  $conf_file='/etc/grid-security/gridftp.conf'
  $conf_template_file='storm/etc/grid-security/gridftp.conf.erb'

  file { 'gftp::configure-gridftp-conf-file':
    ensure  => present,
    path    => $conf_file,
    content => template($conf_template_file),
  }
}
