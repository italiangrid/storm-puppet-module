# @summary StoRM params class
#
# storm class default parameters
#
class storm::params {

  $db_host = lookup('storm::db::host', String, undef, 'localhost')
  $db_user = lookup('storm::db::user', String, undef, 'storm')
  $db_passwd = lookup('storm::db::passwd', String, undef, 'secret')

  $storage_root_dir = '/storage'

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
