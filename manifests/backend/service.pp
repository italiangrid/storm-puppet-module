# @summary StoRM Backend service class
#
class storm::backend::service {

  if defined(Service['mysqld']) {
    $subscribed_to = [Service['mysqld']]
  } else {
    $subscribed_to = []
  }
  service { 'storm-backend-server':
    ensure    => running,
    enable    => true,
    start     => '/usr/bin/systemctl daemon-reload; /usr/bin/systemctl start storm-backend-server',
    restart   => '/usr/bin/systemctl daemon-reload; /usr/bin/systemctl restart storm-backend-server',
    subscribe => $subscribed_to,
  }
  exec { 'configure-info-provider':
    command     => '/usr/libexec/storm-info-provider configure',
    refreshonly => true,
    require     => [Service['storm-backend-server']],
  }
}
