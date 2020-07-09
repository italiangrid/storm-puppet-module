# @summary StoRM Backend install class
#
class storm::backend::install (

) {

  class { 'bdii':
    selinux  => false,
    firewall => false,
  }

  package { 'storm-backend-mp':
    ensure => installed,
  }

  if $storm::backend::install_native_libs_gpfs {
    package { 'storm-native-libs-gpfs' :
      ensure => installed,
    }
  } else {
    # fail in case native libs gfps are needed
    if $storm::backend::fs_type == 'gpfs' {
      fail("You have declared fs_type as 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.")
    } else {
      $storm::backend::storage_areas.each | $sa | {
        if $sa[fs_type] == 'gpfs' {
          fail("Storage area ${sa[name]} is 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.")
        }
      }
    }
  }

  package { 'storm-dynamic-info-provider':
    ensure  => installed,
  }
}
