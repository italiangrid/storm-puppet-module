# @summary StoRM puppet module parent class
#
class storm (

) inherits storm::params {

  contain storm::install
  contain storm::config

  Class['::storm::install']
  -> Class['::storm::config']
}
