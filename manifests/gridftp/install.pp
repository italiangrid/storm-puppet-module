# @summary StoRM GridFTP install class
#
class storm::gridftp::install (

) {

  package { 'storm-globus-gridftp-mp':
    ensure => installed,
  }
}
