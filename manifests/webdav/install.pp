# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {
  package { 'storm-webdav':
    ensure  => '>=1.4.2',
  }
}
