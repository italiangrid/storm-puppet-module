# Class: storm::config
# ===========================
#
class storm::config {

  user { $storm::user_name:
    ensure => present,
  }

  file { $storm::storage_root_dir:
    ensure  => directory,
    owner   => $storm::user_name,
    group   => $storm::user_name,
    mode    => '0755',
    recurse => false,
  }

  if $storm::storage_areas {
    $storm::storage_areas.each | $sa | {
      $name = $sa[name]
      $root_path = $sa[root_path]
      exec { "creates_${name}_root_directory":
        command => "/bin/mkdir -p ${root_path}",
        unless  => "/bin/test -d ${root_path}",
        creates => $root_path,
      }
      exec { "set_ownership_on_${name}_root_directory":
        command => "/bin/chown ${storm::user_name}:${storm::user_name} ${root_path}",
        require => Exec["creates_${name}_root_directory"],
      }
      exec { "set_permissions_on_${name}_root_directory":
        command => "/bin/chmod 755 ${root_path}",
        require => Exec["set_ownership_on_${name}_root_directory"],
      }
    }
  }

  file { $storm::config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $storm::user_name,
    mode    => '0750',
    recurse => true,
  }

  file { $storm::log_dir:
    ensure  => directory,
    owner   => $storm::user_name,
    group   => $storm::user_name,
    mode    => '0755',
    recurse => true,
  }
}
