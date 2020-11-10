# @summary Starting from Puppet module v2.0.0, the management of application.yml
#   file has been removed from storm::webdav class. Site administrators can edit
#   their own configuration files or use this defined type to inject one or more YAML
#   files into the proper directory.
#
# @example
#   class { 'storm::webdav':
#     hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
#   }
#   storm::webdav::application_file { 'application.yml':
#     source => '/path/to/my/application.yml',
#   }
#   storm::webdav::application_file { 'application-wlcg.yml':
#     source => '/path/to/my/application-wlcg.yml',
#   }
#
# @param source
#   The source of file resource. It can be an absolute path or a Puppet module relative path.
#
define storm::webdav::application_file (
  $source,
) {
  file { "/etc/storm/webdav/config/${title}":
    ensure  => present,
    source  => $source,
    owner   => 'root',
    group   => 'storm',
    mode    => '0644',
    notify  => Service['storm-webdav'],
    require => Class['storm::webdav::install'],
  }
}
