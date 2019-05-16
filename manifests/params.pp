# Class: storm::params
# ===========================
#
# storm class default parameters
#
class storm_webdav::params {

  # set OS specific values
  case $::osfamily {
    'RedHat': {
      $storm_user_name = 'storm'
      $storm_storage_root_directory = '/storage'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
