# @summary StoRM params class
#
# storm class default parameters
#
class storm::params {

  $user_name = lookup('storm::user::name', String, undef, 'storm')
  $user_uid = lookup('storm::user::uid', Integer, undef, 1100)
  $user_gid = lookup('storm::user::gid', Integer, undef, 1100)

  $db_host = lookup('storm::db::host', String, undef, 'localhost')
  $db_user = lookup('storm::db::user', String, undef, 'storm')
  $db_passwd = lookup('storm::db::passwd', String, undef, 'secret')

  $storage_root_dir = '/storage'
  $config_dir = '/etc/storm'
  $log_dir = '/var/log/storm'

  case $::osfamily {

    'RedHat': {
      # Only RedHat family is supported.
    }

    # In any other case raise error:
    default: {
      fail("StoRM module not supported on ${::osfamily}/${::operatingsystem}.")
    }
  }
}
