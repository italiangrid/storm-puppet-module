# @!puppet.type.param
# @summary StoRM GridFTP puppet module
#
# Parameters
# ----------
# 
# The StoRM GridFTP configuration parameters are:
#
# * `port`: the port used by GridFTP server service;
# * `port_range`: the range of ports used by transfer sockets; format is 'MIN,MAX';
# * `connections_max`: the number of max allowed connections to server;
#
# @example Example of usage
#    class { 'storm::gridftp':
#      port            => 2811,
#      port_range      => '20000,25000',
#      connections_max => 2000,
#    }
#
# @param port
#   The port used by GridFTP server service.
#
# @param port_range
#   The range of ports used by transfer sockets; format is 'MIN,MAX'.
#
# @param connections_max
#   The number of max allowed connections to server.
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
