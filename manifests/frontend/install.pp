# @summary StoRM Frontend install class
#
class storm::frontend::install (

) {

  # Based on storm-globus-gridftp-mp required rpms
  $required = [
    'fetch-crl',
    'edg-mkgridmap',
    'lcg-expiregridmapdir',
    'cleanup-grid-accounts',
  ]
  package { $required:
    ensure => installed,
  }

  package { 'storm-frontend-server':
    ensure  => installed,
    require => Package[$required],
  }
}
