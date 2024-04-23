# @summary StoRM WebDAV service class
#
class storm::webdav::service {
  service { 'storm-webdav':
    ensure => running,
    enable => true,
  }
  if $storm::webdav::scitag_enabled {
    service { 'flowd':
      ensure => running,
      enable => true,
    }
  }
  if $storm::webdav::nginx_reverse_proxy {
    service { 'nginx':
      ensure => running,
      enable => true,
    }
  }
}
