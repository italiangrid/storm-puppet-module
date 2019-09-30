# @summary StoRM GridFTP puppet module
class storm::gridftp (

  Integer $port = $storm::gridftp::params::port,
  String $port_range = $storm::gridftp::params::port_range,
  Integer $connections_max = $storm::gridftp::params::connections_max,

) inherits storm::gridftp::params {

  contain storm::gridftp::install
  contain storm::gridftp::config
  contain storm::gridftp::service

  Class['storm::gridftp::install']
  -> Class['storm::gridftp::config']
  -> Class['storm::gridftp::service']
}
