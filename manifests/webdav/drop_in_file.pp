# @summary Use this define to inject one or more .conf files
#  into `/etc/systemd/system/storm-webdav.service.d` directory.
#
# @example
#   class { 'storm::webdav':
#     # storm webdav parameters
#   }
#   storm::webdav::drop_in_file { 'override.conf':
#     source => '/path/to/my/override.conf',
#   }
#
# @param source
#   The source of file resource. It can be an absolute path or a Puppet module relative path.
#
define storm::webdav::drop_in_file (
  String $source,
) {
  file { "/etc/systemd/system/storm-webdav.service.d/${title}":
    ensure  => file,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [Class['storm::webdav::install']],
    notify  => [Service['storm-webdav']],
  }
}
