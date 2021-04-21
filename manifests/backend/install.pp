# @summary StoRM Backend install class
#
class storm::backend::install (

) {

  ## StoRM Backend
  package { 'storm-backend-mp':
    ensure  => installed,
  }

  if storm::has_gpfs($storm::backend::fs_type, $storm::backend::storage_areas) {

    ## Native libs GPFS
    package { 'storm-native-libs-gpfs' :
      ensure  => installed,
      require => [Package['storm-backend-mp']],
    }

  }

  ## StoRM Info Provider
  package { 'storm-dynamic-info-provider':
    ensure  => installed,
    require => [Package['storm-backend-mp']],
  }
}
