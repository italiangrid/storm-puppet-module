# @summary StoRM Backend service class
#
class storm::backend::service {

  service { 'storm-backend-server':
    ensure  => running,
    enable  => true,
    require => Package['storm-backend-mp'],
  }
  exec { 'configure-info-provider':
    command     => '/usr/libexec/storm-info-provider configure',
    unless      => '/bin/rpm -q storm-dynamic-info-provider',
    refreshonly => true,
    require     => [Service['storm-backend-server']],
  }
}
