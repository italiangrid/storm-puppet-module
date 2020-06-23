# @summary StoRM DB config class
#
class storm::db::config (

  $fqdn_hostname = $storm::db::fqdn_hostname,
  $storm_username = $storm::db::storm_username,
  $storm_password = $storm::db::storm_password,

) {

  file { '/tmp/storm_db.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_db.sql',
  }

  mysql::db { 'storm_db':
    user     => $storm_username,
    password => $storm_password,
    host     => $fqdn_hostname,
    grant    => 'ALL',
    sql      => '/tmp/storm_db.sql',
    require  => File['/tmp/storm_db.sql'],
  }

  file { '/tmp/storm_be_ISAM.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_be_ISAM.sql',
  }

  mysql::db { 'storm_be_ISAM':
    user     => $storm_username,
    password => $storm_password,
    host     => $fqdn_hostname,
    grant    => 'ALL',
    sql      => '/tmp/storm_be_ISAM.sql',
    require  => File['/tmp/storm_be_ISAM.sql'],
  }
}
