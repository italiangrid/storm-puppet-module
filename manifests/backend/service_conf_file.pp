# @summary
define storm::backend::service_conf_file (
  $source,
) {
  file { "/etc/systemd/system/storm-backend-server.service.d/${title}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [Class['storm::backend::install']],
    notify  => [Service['storm-backend-server']],
  }
}
