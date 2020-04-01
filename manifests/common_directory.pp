# @summary Check if a directory path exists. If not, a new directory is created with specific owner and permissions.
#
# @param path
#   The directory path. Required.
#
# @param owner
#   Directory's owner. Optional. Default: 'storm'.
#
# @param group
#   Directory's group. Optional. Default: 'storm'.
#
# @param permissions
#   Directory's permissions. Optional. Default: '755'.
#
# @param recurse
#   If recursion is enabled. Optional. Default: false.
#
# @example Basic usage
#   storm::common_directory { 'check-root-dir':
#     path => '/storage',
#   }
define storm::common_directory (
  String $path,
  String $owner = 'storm',
  String $group = 'storm',
  String $permissions = '755',
  Boolean $recurse = false,
) {

  exec { "mkdir_${title}":
    command => "/bin/mkdir -p ${path}",
    unless  => "/bin/test -d ${path}",
    creates => $path,
  }

  $opt = $recurse ? {
    true => '-R',
    default => '',
  }
  exec { "chown_${title}":
    command => "/bin/chown ${opt} ${owner}:${group} ${path}",
    require => Exec["mkdir_${title}"],
  }
  exec { "chmod_${title}":
    command => "/bin/chmod ${$permissions} ${path}",
    require => Exec["chown_${title}"],
  }
}
