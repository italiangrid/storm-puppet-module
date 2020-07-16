# @summary StoRM WebDAV service class
#
class storm::webdav::service {

  exec { 'webdav-daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }
  service { 'storm-webdav':
    ensure  => running,
    enable  => true,
    require => Exec['webdav-daemon-reload'],
  }
}
