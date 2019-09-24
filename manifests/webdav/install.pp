# @summary StoRM WebDAV install class
#
class storm::webdav::install (

  $user_name = $storm::webdav::user_name,
  $user_uid = $storm::webdav::user_uid,
  $user_gid = $storm::webdav::user_gid,

) {

  storm::user { 'dav::storm-user':
    user_name => $user_name,
    user_uid  => $user_uid,
    user_gid  => $user_gid,
  }

  package { 'dav::install-storm-webdav-rpm':
    ensure  => installed,
    name    => 'storm-webdav',
    require => Storm::User['dav::storm-user'],
  }
}
