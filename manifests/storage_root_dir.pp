# @summary Check if a storage root directory path exists. If not, a new directory is created with 755 as permissions and the defined owner and group.
#
# @param path
#   The storage root directory path. Required.
#
# @param owner
#   Directory's owner. Required.
#
# @param group
#   Directory's group. Required.
#
# @example Basic usage
#   storm::storage_root_dir { 'check test storage area root dir':
#     path => '/storage/test',
#     owner => 'storm',
#     group => 'storm',
#   }
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
