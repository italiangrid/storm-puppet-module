# storm::user
# ===========================
#
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
