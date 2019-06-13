# Class: storm::service_hostcert
# ===========================
#
class storm::service_hostcert (
  String $hostcert,
  String $hostkey,
  String $owner,
  String $group,
) {

  file { $hostcert:
    ensure => present,
    mode   => '0644',
    owner  => $owner,
    group  => $group,
    source => '/etc/grid-security/hostcert.pem',
  }

  file { $hostkey:
    ensure => present,
    mode   => '0400',
    owner  => $owner,
    group  => $group,
    source => '/etc/grid-security/hostkey.pem',
  }
}
