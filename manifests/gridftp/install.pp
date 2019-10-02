# @summary StoRM GridFTP install class
#
class storm::gridftp::install (

) {

  package { 'gftp::install-storm-globus-gridftp-server':
    ensure => installed,
    name   => 'storm-globus-gridftp-server',
  }
}
