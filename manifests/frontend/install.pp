# @summary StoRM Frontend install class
#
class storm::frontend::install (

) {

  package { 'storm-frontend-server-mp':
    ensure => installed,
  }
}
