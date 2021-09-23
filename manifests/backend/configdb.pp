# @summary StoRM Backend DB config class
#
class storm::backend::configdb (

) {

  file { '/tmp/storm_db.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_db.sql',
  }

  file { '/tmp/storm_be_ISAM.sql':
    ensure => present,
    source => 'puppet:///modules/storm/storm_be_ISAM.sql',
  }

  $paths = ['/bin', '/usr/bin', '/sbin', '/usr/sbin', '/usr/local/bin']
  $storm_db_query = 'use storm_db;select major from db_version;'
  $check_storm_db = "! mysql -h ${storm::backend::db_hostname} -u${storm::backend::db_username} -p${storm::backend::db_password} -e \"${storm_db_query}\""
  exec{ 'storm_db-import':
    command     => 'mysql storm_db < /tmp/storm_db.sql',
    onlyif      => $check_storm_db,
    logoutput   => true,
    environment => "HOME=${::root_home}",
    path        => $paths,
    provider    => 'shell',
    require     => [File['/tmp/storm_db.sql']],
  }
  $storm_be_isam_query = 'use storm_be_ISAM;select major from db_version;'
  $check_storm_be_isam = "! mysql -h ${storm::backend::db_hostname} -u${storm::backend::db_username} -p${storm::backend::db_password} -e \"${storm_be_isam_query}\""
  exec{ 'storm_be_ISAM-import':
    command     => 'mysql storm_be_ISAM < /tmp/storm_be_ISAM.sql',
    onlyif      => $check_storm_be_isam,
    logoutput   => true,
    environment => "HOME=${::root_home}",
    path        => $paths,
    provider    => 'shell',
    require     => [File['/tmp/storm_be_ISAM.sql']],
  }
}
