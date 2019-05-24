# Class: storm::webdav
# ===========================
#
class storm::webdav::install {

  package { 'storm-webdav':
    ensure => present,
  }
}
