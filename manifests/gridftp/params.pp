# @summary StoRM GridFTP params class
#
class storm::gridftp::params (
) inherits storm::params {

  $port = lookup('storm::gridftp::port', Integer, undef, 2811)
  $port_range = lookup('storm::gridftp::port_range', String, undef, '20000,25000')
  $connections_max = lookup('storm::gridftp::connections_max', Integer, undef, 2000)
}
