# @summary StoRM DB params class
#
class storm::db::params (

) inherits storm::params {

  $fqdn_hostname = lookup('storm::db::fqdn_hostname', String, undef, 'backend.example.org')
  $root_password = lookup('storm::db::root_password', String, undef, 'storm')
  $storm_username = lookup('storm::db::storm_username', String, undef, 'storm')
  $storm_password = lookup('storm::db::storm_password', String, undef, 'bluemoon')
  $max_connections = lookup('storm::db::max_connections', Integer, undef, 1024)

}
