# @summary StoRM Backend service class
#
class storm::backend::service {

  exec { 'backend-daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }
  service { 'storm-backend-server':
    ensure  => running,
    enable  => true,
    require => Exec['backend-daemon-reload'],
  }
  exec { 'configure-info-provider':
    command     => '/usr/libexec/storm-info-provider configure',
    refreshonly => true,
    require     => [Service['storm-backend-server']],
  }
}
