# @summary StoRM Frontend service class
#
class storm::frontend::service {
  service { 'storm-frontend-server':
    ensure  => running,
    enable  => true,
    require => Package['storm-frontend-mp'],
  }
}
