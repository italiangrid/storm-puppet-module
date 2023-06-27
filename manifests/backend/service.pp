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
    subscribe => $subscribed_to,
  }
  exec { 'configure-info-provider':
    command   => '/usr/libexec/storm-info-provider configure',
    tries     => 5,
    try_sleep => 2,
    require   => [Service['storm-backend-server']],
  }
}
