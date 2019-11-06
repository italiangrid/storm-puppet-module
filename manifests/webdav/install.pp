# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {

  package { 'storm-webdav':
    ensure  => installed,
  }
}
