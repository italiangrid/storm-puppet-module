# storm::storage_root_dir
# ===========================
#
define storm::storage_root_dir (
  String $path,
  String $owner,
  String $group,
) {

  exec { "${title}_create_root_directory":
    command => "/bin/mkdir -p ${path}",
    unless  => "/bin/test -d ${path}",
    creates => $path,
  }
  exec { "${title}_set_ownership_on_root_directory":
    command => "/bin/chown ${owner}:${group} ${path}",
    require => Exec["${title}_create_root_directory"],
  }
  exec { "${title}_set_permissions_on_root_directory":
    command => "/bin/chmod 755 ${path}",
    require => Exec["${title}_set_ownership_on_root_directory"],
  }
}
