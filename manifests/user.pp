# @summary Create a UNIX user. Optionally with a required uid and gid.
#
# @param user_name
#   The user name. Required.
#
# @param user_uid
#   User's id. Optional.
#
# @param user_gid
#   User's group id. Optional.
#
# @example Basic usage
#   storm::user { 'service user':
#     user_name => 'storm',
#   }
define storm::user (
  String $user_name,
  Integer $user_uid = 1100,
  Integer $user_gid = 1100,
) {

  group { $user_name:
    ensure => present,
    gid    => $user_gid,
  }

  user { $user_name:
    ensure => present,
    uid    => $user_uid,
    gid    => $user_name,
  }
}
