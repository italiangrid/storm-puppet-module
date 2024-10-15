# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {
  package { 'storm-webdav':
    ensure  => '>=1.4.2',
  }
  if $storm::webdav::scitag {
    $el = $facts['os']['distro']['release']['major']
    yumrepo { 'scitags-repo':
      ensure   => present,
      descr    => 'SciTags stable repo',
      enabled  => 1,
      gpgcheck => 0,
      baseurl  => "https://linuxsoft.cern.ch/repos/scitags${el}al-stable/x86_64/os/",
    }
    package { 'python3-scitags':
      ensure  => 'installed',
      require => Yumrepo['scitags-repo'],
    }
  }
}
