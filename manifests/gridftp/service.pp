# @summary StoRM GridFTP service class
#
class storm::gridftp::service {

  service { 'storm-globus-gridftp':
    ensure => running,
    enable => true,
  }
}
