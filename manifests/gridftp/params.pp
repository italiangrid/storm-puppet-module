# @summary StoRM GridFTP params class
#
class storm::gridftp::params (
) inherits storm::params {

  $port = lookup('storm::gridftp::port', Integer, undef, 2811)
  $port_range = lookup('storm::gridftp::port_range', String, undef, '20000,25000')
  $connections_max = lookup('storm::gridftp::connections_max', Integer, undef, 2000)

  $log_single = lookup('storm::gridftp::log_single', String, undef, '/var/log/storm/storm-gridftp-session.log')
  $log_transfer = lookup('storm::gridftp::log_transfer', String, undef, '/var/log/storm/storm-globus-gridftp.log')

  $redirect_lcmaps_log = lookup('storm::gridftp::redirect_lcmaps_log', Boolean, undef, false)
  $llgt_log_file = lookup('storm::gridftp::llgt_log_file', String, undef, '/var/log/storm/storm-gridftp-lcmaps.log')

  $lcmaps_debug_level = lookup('storm::gridftp::lcmaps_debug_level', Integer, undef, 3)
  $lcas_debug_level = lookup('storm::gridftp::lcas_debug_level', Integer, undef, 3)
}
