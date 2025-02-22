# @summary StoRM WebDAV service class
#
class storm::webdav::service {
  service { 'storm-webdav':
    ensure => running,
    enable => true,
  }
  if $storm::webdav::scitags_enabled {
    service { 'flowd':
      ensure => running,
      enable => true,
    }
  }
}
