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
#
# @param log_single
#   Session log file path. Default is: /var/log/storm/storm-gridftp-session.log
#
# @param log_transfer
#   Transfer log file path. Default is: /var/log/storm/storm-globus-gridftp.log
#
# @param redirect_lcmaps_log
#   If true, redirect the LCMAPS log to the file specified by 'llgt_log_file'.
#
# @param llgt_log_file
#   The LCMAPS log file used if 'redirect_lcmaps_log' is true.
#
# @param lcmaps_debug_level
#   The LCMAPS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default: 3 (INFO)
#
# @param lcas_debug_level
#   The LCAS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default: 3 (INFO)
#
# @param load_storm_dsi_module
#   Enable/Disable StoRM DSI module. Default: true (enabled)
#
# @param log_level
#
# @param data_interface
#   (Optional) Hostname or IP address of the interface to use for data connections.
#   Set this to your external IP address in case your public address is different from
#   your local address (e.g. the floating IP address of a Virtual Machine).
#
class storm::gridftp (

  Integer $port,
  String $port_range,
  Integer $connections_max,

  String $log_single,
  String $log_transfer,

  Boolean $redirect_lcmaps_log,
  String $llgt_log_file,

  Integer $lcmaps_debug_level,
  Integer $lcas_debug_level,

  Boolean $load_storm_dsi_module,

  String $log_level,

  Optional[String] $data_interface,

) {
  contain storm::gridftp::install
  contain storm::gridftp::config
  contain storm::gridftp::service

  Class['storm::gridftp::install']
  -> Class['storm::gridftp::config']
  -> Class['storm::gridftp::service']
}
