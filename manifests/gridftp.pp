# @!puppet.type.param
# @summary StoRM GridFTP installation and configuration class.
#
# @example Example of usage with default configuration values
#    include 'storm::gridftp'
#
# @example Example of usage with some custom parameters
#    class { 'storm::gridftp':
#      port_range => '20000,40000',
#      connections_max => 5000,
#    }
#
# @example Example of usage with a provided gridftp.conf
#    class { 'storm::gridftp':
#      gridftp_conf_file => '/path/to/your/gridftp.conf',
#    }
#
# @param gridftp_conf_file Use this to provide a source file to be used as your own /etc/grid-security/gridftp.conf configuration file.
#   Ignored if set to an empty string. In case of a proper value, all the other class parameters will be ignored.
#   Default value: empty string.
#
# @param port The port used by GridFTP server service. Default value: 2811.
#
# @param port_range The range of ports used by transfer sockets; format is 'MIN,MAX'. Default value: '20000,25000'.
#
# @param connections_max The number of max allowed connections to server. Default value: 2000.
#
# @param log_level A comma separated list of levels from: ERROR, WARN, INFO, TRANSFER, DUMP, ALL. TRANSFER includes the same
#  statistics that are sent to the separate transfer log when -log-transfer is used. Example: error,warn,info. You may also specify a
#  numeric level of 1-255. Default value: 'ERROR,WARN,INFO'.
#
# @param log_single Session log file path. Default value: '/var/log/storm/storm-gridftp-session.log'.
#
# @param log_transfer Transfer log file path. Default value: '/var/log/storm/storm-globus-gridftp.log'.
#
# @param config_base_path Base path to use when config and log path options are not full paths. By default this is the current directory
#  when the process is started. Default value: '/'.
#
# @param redirect_lcmaps_log If true, redirect the LCMAPS log to the file specified by 'llgt_log_file'. Default value: false.
#
# @param llgt_log_file The LCMAPS log file used if 'redirect_lcmaps_log' is true. Default value: '/var/log/storm/storm-gridftp-lcmaps.log'.
#
# @param lcmaps_debug_level The LCMAPS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default value: 3 (INFO)
#
# @param lcas_debug_level The LCAS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default value: 3 (INFO)
#
# @param load_storm_dsi_module Enable/Disable StoRM DSI module. Default value: true (enabled)
#
class storm::gridftp (

  String $gridftp_conf_file,

  Integer $port,
  String $port_range,
  Integer $connections_max,

  String $log_level,
  String $log_single,
  String $log_transfer,

  String $config_base_path,

  Boolean $redirect_lcmaps_log,
  String $llgt_log_file,

  Integer $lcmaps_debug_level,
  Integer $lcas_debug_level,

  Boolean $load_storm_dsi_module,

) {

  contain storm::gridftp::install
  contain storm::gridftp::config
  contain storm::gridftp::service

  Class['storm::gridftp::install']
  -> Class['storm::gridftp::config']
  -> Class['storm::gridftp::service']
}
