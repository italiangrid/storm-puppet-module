# @summary StoRM Backend install class
#
class storm::backend::install (

) {

  package { 'storm-backend-server-mp':
    ensure => installed,
  }
}
