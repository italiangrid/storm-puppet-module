# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {
  package { 'storm-webdav':
    ensure  => '>=1.4.2',
  }
  if $storm::webdav::nginx_reverse_proxy {
    $el = $facts['os']['distro']['release']['major']
    yumrepo { 'nginx-stable-repo':
      ensure   => present,
      descr    => 'nginx stable repo',
      enabled  => 1,
      gpgcheck => 1,
      baseurl  => "http://nginx.org/packages/centos/${el}/x86_64/",
      gpgkey   => 'https://nginx.org/keys/nginx_signing.key',
    }
    package { 'nginx':
      ensure  => 'installed',
      require => Yumrepo['nginx-stable-repo'],
    }
    yumrepo { 'voms':
      ensure   => present,
      descr    => 'VOMS stable repo',
      baseurl  => "https://repo.cloud.cnaf.infn.it/repository/voms-rpm-stable/centos${el}/",
      enabled  => 1,
      gpgcheck => 0,
    }
    yumrepo { 'storage-generic':
      ensure   => present,
      descr    => 'Storage Generic repo managed by Puppet',
      baseurl  => 'http://os-server.cnaf.infn.it/distro/Storage/generic/',
      enabled  => 1,
      gpgcheck => 0,
    }
    package { 'nginx-module-http-voms':
      ensure  => 'installed',
      require => Yumrepo['storage-generic'],
    }
  }
}
