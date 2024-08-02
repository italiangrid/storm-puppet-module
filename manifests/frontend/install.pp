# @summary StoRM Frontend install class
#
class storm::frontend::install (

) {
  ## StoRM Frontend
  package { 'storm-frontend-server':
    ensure  => '>=1.8.16',
  }
}
