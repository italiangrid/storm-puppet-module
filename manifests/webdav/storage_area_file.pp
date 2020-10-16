# @summary
define storm::webdav::storage_area_file (
  $source,
) {
  file { "/etc/storm/webdav/sa.d/${title}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'storm',
    mode    => '0644',
    notify  => Service['storm-webdav'],
    require => Class['storm::webdav::install'],
  }
}
