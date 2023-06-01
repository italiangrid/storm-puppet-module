# @summary Storage Areas can be configured singularly by using this defined type.
#   This strategy allows site administrators to keep their manifests unaware of
#   the improvements on StoRM WebDAV code. For example, if a new property is added
#   into Storage Area configuration files, you haven't to update your Puppet module
#   and all the service configuration will continue working.
#
# @example
#   class { 'storm::webdav':
#     hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
#   }
#   storm::webdav::storage_area_file { 'test.vo.properties':
#     source => '/path/to/my/test.vo.properties',
#   }
#   storm::webdav::storage_area_file { 'test.vo.2.properties':
#     source => '/path/to/my/test.vo.2.properties',
#   }
#
# @param source
#   The source of file resource. It can be an absolute path or a Puppet module relative path.
#
define storm::webdav::storage_area_file (
  String $source,
) {
  file { "/etc/storm/webdav/sa.d/${title}":
    ensure  => file,
    source  => $source,
    owner   => 'root',
    group   => 'storm',
    mode    => '0644',
    notify  => Service['storm-webdav'],
    require => Class['storm::webdav::install'],
  }
}
