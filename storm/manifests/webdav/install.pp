# Class: storm::webdav::install
# ===========================
#
class storm::webdav::install {

  package { 'storm-webdav':
    ensure => installed,
  }
}
