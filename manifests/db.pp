# @summary StoRM Database class
#
# @param fqdn_hostname
#   The Fully Qualyfied Domain Name of the host where database is installed. Required.
#
# @param root_password
#   The MySQL root user password. Optional.
#
# @param storm_username
#   The database user used by StoRM services. Default: 'storm'. Optional.
#
# @param storm_password
#   The password of database user used by StoRM services. Default: 'bluemoon'. Optional.
#
# @example Install and configure database as follow:
#   class { 'storm::db':
#     fqdn_hostname  => 'be.test.example',
#     root_password  => 'secret',
#     storm_password => 'secret',
#   }
class storm::db (

  String $fqdn_hostname = $storm::db::params::fqdn_hostname,
  String $root_password = $storm::db::params::root_password,
  String $storm_username = $storm::db::params::storm_username,
  String $storm_password = $storm::db::params::storm_password,

) inherits storm::db::params {

  contain storm::db::install
  contain storm::db::config

  Class['storm::db::install']
  -> Class['storm::db::config']

}
