# @summary StoRM Backend service class
#
class storm::backend::service {

  service { 'storm-backend-server':
    ensure  => running,
    enable  => true,
    require => Package['storm-backend-mp'],
  }
}
