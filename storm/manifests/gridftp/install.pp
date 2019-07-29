# @summary StoRM GridFTP install class
#
class storm::gridftp::install (

) {

  package { 'gftp::install-storm-globus-gridftp-mp':
    ensure => installed,
    name   => 'emi-storm-globus-gridftp-mp',
  }
}
