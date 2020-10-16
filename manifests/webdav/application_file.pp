# @summary
define storm::webdav::application_file (
  $source,
) {
  file { "/etc/storm/webdav/config/${title}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'storm',
    mode    => '0644',
    notify  => Service['storm-webdav'],
    require => Class['storm::webdav::install'],
  }
}
