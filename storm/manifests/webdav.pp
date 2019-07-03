# Class: storm::webdav
# ===========================
#
class storm::webdav {

  contain storm::webdav::install
  contain storm::webdav::config
  contain storm::webdav::service

  Class['storm::webdav::install']
  -> Class['storm::webdav::config']
  -> Class['storm::webdav::service']
}
