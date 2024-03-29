# @summary StoRM Backend install class
#
class storm::backend::install (

) {
  ## StoRM Backend
  package { 'storm-backend-server':
    ensure  => '>=1.11.22',
  }

  if $storm::backend::fs_type == 'gpfs' {
    ## Native libs GPFS
    package { 'storm-native-libs-gpfs' :
      ensure  => '>1.0.7',
      require => [Package['storm-backend-server']],
    }
  } else {
    $storm::backend::storage_areas.each | $sa | {
      if $sa['fs_type'] == 'gpfs' {
        ## Native libs GPFS
        package { 'storm-native-libs-gpfs' :
          ensure  => '>1.0.7',
          require => [Package['storm-backend-server']],
        }
        break()
      }
    }
  }

  ## StoRM Info Provider
  package { 'storm-dynamic-info-provider':
    ensure  => '>=1.8.3',
    require => [Package['storm-backend-server']],
  }
}
