# @summary Copy hostcert.pem and hostkey.pem from '/etc/grid-security' to the hostcert and hostkey required path, with owner and group specified.
#
# @param hostcert
#   The host certificate path where '/etc/grid-security/hostcert.pem' is copied. Required.
#
# @param hostkey
#   The host key path where '/etc/grid-security/hostkey.pem' is copied. Required.
#
# @param owner
#   Certificate and key's owner. Required.
#
# @param group
#   Certificate and key's group name. Required.
#
# @example Basic usage
#   storm::service_hostcert { 'storm-webdav service host credentials':
#     hostcert => '/etc/grid-security/storm-webdav/hostcert.pem',
#     hostkey => '/etc/grid-security/storm-webdav/hostkey.pem'
#     owner => 'storm',
#     group => 'storm',
#   }
define storm::service_hostcert (
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
