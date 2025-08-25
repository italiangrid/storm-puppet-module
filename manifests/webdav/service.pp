# @summary StoRM WebDAV service class
#
class storm::webdav::service {
  service { 'storm-webdav':
    ensure => running,
    enable => true,
  }
  if $storm::webdav::scitags_enabled {
    case $storm::webdav::scitags_daemon {
      'flowd': {
        service { 'flowd':
          ensure => running,
          enable => true,
        }
      }
      'flowd-go': {
        service { 'flowd-go':
          ensure => running,
          enable => true,
        }
      }
    }
  }
}
