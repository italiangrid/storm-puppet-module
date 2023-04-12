# @summary StoRM Frontend install class
#
class storm::frontend::install (

) {
  package { 'storm-frontend-mp':
    ensure  => installed,
  }
}
