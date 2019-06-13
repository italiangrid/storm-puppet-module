# Class: storm::repo
# ===========================
#
class storm::repo (
  Array[Enum['stable', 'beta', 'nightly']] $installed = ['stable', 'beta', 'nightly'],
  Array[Enum['stable', 'beta', 'nightly']] $enabled = ['stable'],
  Array[Struct[{ name => String, url => String }]] $customs = [],
) {

  if ($installed.length > 0) {

    $repodir = '/etc/yum.repos.d'
    $el = $::operatingsystemmajrelease

    $installed.each | $reponame | {

      exec {"download-${reponame}-repo-el${el}":
        command => "/bin/yum-config-manager --add-repo=https://repo.cloud.cnaf.infn.it/repository/storm/${reponame}/storm-${reponame}-centos${el}.repo",
        creates => "${repodir}/storm-${reponame}-centos${el}.repo",
      }
      if $reponame in $enabled {
        exec {"enable-${reponame}-repo-el${el}":
          command => "/bin/yum-config-manager --enable storm-${reponame}-centos${el}",
        }
      } else {
        exec {"disable-${reponame}-repo-el${el}":
          command => "/bin/yum-config-manager --disable storm-${reponame}-centos${el}",
        }
      }
    }
  }

  $customs.each | $repo | {
    $name = $repo[name]
    $url = $repo[url]
    exec {"download-custom-${name}-repo":
      command => "/bin/yum-config-manager --add-repo=${url}",
    }
  }
}
