# @summary Choose which StoRM repository you want to intall and enable. Also a custom list of repository URL can be specified.
#
# @param installed
#   The list of repositories that have to be installed. Allowed values are `stable`, `beta` and `nightly`. Optional.
#
# @param enabled
#   The list of repositories that have to be enabled. Allowed values are `stable`, `beta` and `nightly`. Optional.
#
# @param extra
#   A list of repository that have to be created. Optional.
#
# @param install_umd
#   Install UMD4 repositories. Default: false.
#
# @param install_epel
#   Install EPEL repositories. Default: false.
#
# @example Install all the repositories and enable only nightly repo as follow:
#   class { 'storm::repo':
#     enabled => ['stable'],
#   }
class storm::repo (

  Array[Enum['stable', 'beta', 'nightly']] $installed = ['stable', 'beta', 'nightly'],
  Array[Enum['stable', 'beta', 'nightly']] $enabled = ['stable'],

  Array[Storm::CustomRepo] $extra = [],

  Boolean $install_umd = false,
  Boolean $install_epel = false,

) {

  $base = 'https://repo.cloud.cnaf.infn.it/repository'
  $el = $::operatingsystemmajrelease

  $installed.each | $repo | {

    $enabled = $repo in $enabled ? { true => 1, default => 0 }
    $name = "storm-${repo}-centos${el}"
    $baseurl = "${base}/storm-rpm-${repo}/centos${el}/"

    yumrepo { $name:
      ensure   => present,
      descr    => $name,
      baseurl  => $baseurl,
      enabled  => $enabled,
      protect  => 1,
      priority => 1,
      gpgcheck => 0,
    }
  }

  $extra.each | $repo | {

    $name = $repo[name]
    $baseurl = $repo[baseurl]

    yumrepo { $name:
      ensure   => present,
      descr    => $name,
      baseurl  => $baseurl,
      enabled  => 1,
      protect  => 1,
      priority => 1,
      gpgcheck => 0,
    }
  }

  if $install_umd {

    $platform = $::operatingsystemmajrelease
    case $platform {
      '6' : {
        $umd_repo = 'http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm'
      }
      '7' : {
        $umd_repo = 'http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm'
      }
      default : {
        fail('Unsupported platform for UMD-4')
      }
    }
    package { 'umd-release':
      ensure => installed,
      source => $umd_repo,
    }
  }

  if $install_epel {

    package { 'epel-release':
      ensure => latest,
    }

  }
}
