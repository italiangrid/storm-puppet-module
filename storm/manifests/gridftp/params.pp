# @summary StoRM GridFTP params class
#
class storm::gridftp::params (
) inherits storm::params {

  $gridftp_with_dsi = lookup('storm::grdiftp::params::gridftp_with_dsi', Enum['yes', 'no'], undef, 'yes')

  $tcp_port_range_min = lookup('storm::gridftp::params::tcp_port_range_min', Integer, undef, 20000)
  $tcp_port_range_max = lookup('storm::gridftp::params::tcp_port_range_max', Integer, undef, 25000)

  $connections_max = lookup('storm::gridftp::params::connections_max', Integer, undef, 2000)
}
