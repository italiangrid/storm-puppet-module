# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {
  package { 'storm-webdav':
    ensure  => '>=1.4.2',
  }
  if $storm::webdav::scitags_enabled {
    $el = $facts['os']['distro']['release']['major']
    yumrepo { 'scitags-repo':
      ensure   => present,
      descr    => 'SciTags stable repo',
      enabled  => 1,
      gpgcheck => 0,
      baseurl  => "https://linuxsoft.cern.ch/repos/scitags${el}al-stable/x86_64/os/",
    }
    case $storm::webdav::scitags_daemon {
      'flowd': {
        package { 'python3-scitags':
          ensure  => 'installed',
          require => Yumrepo['scitags-repo'],
        }
      }
      'flowd-go': {
        package { 'flowd-go':
          ensure  => '>=2.4.0',
          require => Yumrepo['scitags-repo'],
        }
      }
    }
  }
}
