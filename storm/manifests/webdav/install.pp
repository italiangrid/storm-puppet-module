# @summary StoRM WebDAV install class
#
class storm::webdav::install (

  $ns = $storm::webdav::ns,

  $user_name = $storm::webdav::user_name,
  $user_uid = $storm::webdav::user_uid,
  $user_gid = $storm::webdav::user_gid,

) {

  storm::user { "${ns}::storm-user":
    user_name => $user_name,
    user_uid  => $user_uid,
    user_gid  => $user_gid,
  }

  package { "${ns}::install-storm-webdav-rpm":
    ensure  => installed,
    name    => 'storm-webdav',
    require => Storm::User["${ns}::storm-user"],
  }
}
