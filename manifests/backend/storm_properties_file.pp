# @summary Define your own storm.properties file with an absolute path or a Puppet module relative path.
#
# @example
#  storm::backend::storm_properties_file { 'my-storm-properties':
#    source => '/path/to/my/storm.properties',
#  }
#
# @param source The source of your storm.properties file resource. It can be an absolute path or a Puppet module relative path.
#
define storm::backend::storm_properties_file (
  $source,
) {
  file { '/etc/storm/backend-server/storm.properties':
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'storm',
    require => [Class['storm::backend::install']],
    notify  => [Service['storm-backend-server']],
  }
}
