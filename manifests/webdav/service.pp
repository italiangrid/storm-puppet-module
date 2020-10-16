# @summary StoRM WebDAV service class
#
class storm::webdav::service {

  service { 'storm-webdav':
    ensure => running,
    enable => true,
    start  => '/usr/bin/systemctl daemon-reload; /usr/bin/systemctl start storm-webdav',
  }
}
