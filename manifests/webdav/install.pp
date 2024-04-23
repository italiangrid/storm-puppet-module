# @summary StoRM WebDAV install class
#
class storm::webdav::install (

) {
  package { 'storm-webdav':
    ensure  => '>=1.4.2',
  }
  $el = $facts['os']['distro']['release']['major']
  if $storm::webdav::scitag_enabled {
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
  if $storm::webdav::nginx_reverse_proxy {
    yumrepo { 'egi-trustanchors.repo':
      ensure   => present,
      descr    => 'EGI-trustanchors',
      name     => 'EGI-trustanchors',
      enabled  => 1,
      gpgcheck => 1,
      baseurl  => 'http://repository.egi.eu/sw/production/cas/1/current/',
      gpgkey   => 'http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3',
    }
    package { 'ca-policy-egi-core':
      ensure  => 'latest',
      require => Yumrepo['egi-trustanchors.repo'],
      notify  => Exec['refresh-bundle'],
    }
	# whenever ca-policy-egi-core is updated, need to refresh certificates bundle for nginx
    file { '/root/refresh-bundle.sh':
      ensure  => file,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      source  => "puppet:///modules/storm/refresh-bundle.sh",
    }
    exec {'refresh-bundle':
      refreshonly => true,
      command     => '/bin/bash /root/refresh-bundle.sh';
    }
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
    case $facts['os']['name'] {
      'CentOS', 'Scientific': {
        yumrepo { 'voms':
          ensure   => present,
          descr    => 'VOMS stable repo',
          baseurl  => "https://repo.cloud.cnaf.infn.it/repository/voms-rpm-stable/centos${el}/",
          enabled  => 1,
          gpgcheck => 0,
        }
      }
      'RedHat', 'AlmaLinux': {
        yumrepo { 'voms':
          ensure   => present,
          descr    => 'VOMS stable repo',
          baseurl  => "https://repo.cloud.cnaf.infn.it/repository/voms-rpm-stable/redhat${el}/",
          enabled  => 1,
          gpgcheck => 0,
        }
      }
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
