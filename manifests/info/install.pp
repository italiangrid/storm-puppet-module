# @summary StoRM Info install class
#
class storm::info::install (

) {

  package { 'storm-dynamic-info-provider':
    ensure  => installed,
  }
}


