# @summary Use this define to inject one or more .conf files
#  into `/etc/systemd/system/storm-backend-server.service.d` directory.
#
# @example
#   class { 'storm::backend':
#     # backend parameters
#   }
#   storm::backend::drop_in_file { 'override.conf':
#     source => '/path/to/my/override.conf',
#   }
#
# @param source
#   The source of file resource. It can be an absolute path or a Puppet module relative path.
#
define storm::backend::drop_in_file (
  $source,
) {
  file { "/etc/systemd/system/storm-backend-server.service.d/${title}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [Class['storm::backend::install']],
    notify  => [Service['storm-backend-server']],
  }
}
