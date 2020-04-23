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
# @example Install all the repositories and enable only nightly repo as follow:
#   class { 'storm::repo':
#     enabled => ['nightly'],
#   }
class storm::repo (

  Array[Enum['stable', 'beta', 'nightly']] $installed = ['stable', 'beta', 'nightly'],
  Array[Enum['stable', 'beta', 'nightly']] $enabled = ['stable'],

  Array[Storm::CustomRepo] $extra = [],

) {

  $base = 'https://repo.cloud.cnaf.infn.it/repository/storm'
  $el = $::operatingsystemmajrelease

  $installed.each | $repo | {

    $enabled = $repo in $enabled ? { true => 1, default => 0 }
    $name = "storm-${repo}-centos${el}"
    $baseurl = "${base}/${repo}/el${el}/x86_64/"

    yumrepo { $name:
      ensure   => present,
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
      baseurl  => $baseurl,
      enabled  => 1,
      protect  => 1,
      priority => 1,
      gpgcheck => 0,
    }
  }
}
