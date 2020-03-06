# @summary StoRM GridFTP install class
#
class storm::gridftp::install (

) {

  $dependencies = [
    'umd-release',
    'fetch-crl',
    'edg-mkgridmap',
    'lcas',
    'lcas-plugins-basic',
    'lcas-plugins-voms',
    'lcmaps',
    'lcmaps-plugins-basic',
    'lcmaps-without-gsi',
    'lcmaps-plugins-voms',
    'lcas-lcmaps-gt4-interface',
    'lcg-expiregridmapdir',
    'cleanup-grid-accounts',
  ]
  package { $dependencies:
    ensure => installed,
  }

  package { 'storm-globus-gridftp-server':
    ensure => installed,
  }

}
