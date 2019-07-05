# Class: storm::webdav::service
# ===========================
#
class storm::webdav::service {

  service { 'storm-webdav':
    ensure => running,
    enable => true,
  }
}
