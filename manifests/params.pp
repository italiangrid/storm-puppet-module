# Class: storm::params
# ===========================
#
# storm class default parameters
#
class storm::params {

  # set OS specific values
  case $::osfamily {
    'RedHat': {
      $user_name = 'storm'
      $storage_root_directory = '/storage'
      $storage_area = []
    }
    default: {
      fail('StoRM module is supported only on RedHat based system.')
    }
  }
}
