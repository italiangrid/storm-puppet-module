# @summary StoRM GridFTP puppet module
class storm::gridftp (

  Enum['yes', 'no'] $gridftp_with_dsi = $storm::gridftp::params::gridftp_with_dsi,
  Integer $tcp_port_range_min = $storm::gridftp::params::tcp_port_range_min,
  Integer $tcp_port_range_max = $storm::gridftp::params::tcp_port_range_max,

  Integer $connections_max = $storm::gridftp::params::connections_max,

) inherits storm::gridftp::params {

  contain storm::gridftp::install
  contain storm::gridftp::config
  contain storm::gridftp::service

  Class['storm::gridftp::install']
  -> Class['storm::gridftp::config']
  -> Class['storm::gridftp::service']
}
