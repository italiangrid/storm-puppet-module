# @summary StoRM GridFTP config class
#
class storm::gridftp::config (

  $port = $storm::gridftp::port,
  $port_range = $storm::gridftp::port_range,
  $connections_max = $storm::gridftp::connections_max,

) {

  $conf_file='/etc/gridftp.conf'
  $conf_template_file='storm/etc/gridftp.conf.erb'

  file { 'gftp::configure-gridftp-conf-file':
    ensure  => present,
    path    => $conf_file,
    content => template($conf_template_file),
    notify  => Service['storm-globus-gridftp'],
    require => Package['storm-globus-gridftp-mp'],
  }
}
