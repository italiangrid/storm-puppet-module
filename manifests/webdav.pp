# Class: storm::webdav
# ===========================
#
class storm::webdav (

) inherits storm {

  contain storm::webdav::install
  contain storm::webdav::config

}
