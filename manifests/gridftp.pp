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
# @param lcmaps_db_file
#   Custom lcmaps db file path
#
# @param lcas_db_file
#   Custom lcas db file path
#
# @param lcas_ban_users_file
#   Custom lcas banned users file path
#
# @param gsi_authz_file
#   Custom gsi authz file path
#
class storm::gridftp (

  Integer $port = $storm::gridftp::params::port,
  String $port_range = $storm::gridftp::params::port_range,
  Integer $connections_max = $storm::gridftp::params::connections_max,

  String $log_single = $storm::gridftp::params::log_single,
  String $log_transfer = $storm::gridftp::params::log_transfer,

  Boolean $redirect_lcmaps_log = $storm::gridftp::params::redirect_lcmaps_log,
  String $llgt_log_file = $storm::gridftp::params::llgt_log_file,

  Integer $lcmaps_debug_level = $storm::gridftp::params::lcmaps_debug_level,
  Integer $lcas_debug_level = $storm::gridftp::params::lcas_debug_level,

  Boolean $load_storm_dsi_module = $storm::gridftp::params::load_storm_dsi_module,

  String $lcmaps_db_file = $storm::gridftp::params::lcmaps_db_file,
  String $lcas_db_file = $storm::gridftp::params::lcas_db_file,
  String $lcas_ban_users_file = $storm::gridftp::params::lcas_ban_users_file,
  String $gsi_authz_file = $storm::gridftp::params::gsi_authz_file,

) inherits storm::gridftp::params {

  contain storm::gridftp::install
  contain storm::gridftp::config
  contain storm::gridftp::service

  Class['storm::gridftp::install']
  -> Class['storm::gridftp::config']
  -> Class['storm::gridftp::service']
}
