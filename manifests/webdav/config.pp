# @summary StoRM WebDAV config class
#
class storm::webdav::config (

) {
  file { '/var/lib/storm-webdav/work':
    ensure  => directory,
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }

  # Service's host credentials directory
  file { '/etc/grid-security/storm-webdav':
    ensure  => directory,
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }
  # Service's hostcert
  file { '/etc/grid-security/storm-webdav/hostcert.pem':
    ensure  => file,
    mode    => '0644',
    owner   => 'storm',
    group   => 'storm',
    source  => '/etc/grid-security/hostcert.pem',
    require => File['/etc/grid-security/storm-webdav'],
  }
  # Service's hostkey
  file { '/etc/grid-security/storm-webdav/hostkey.pem':
    ensure  => file,
    mode    => '0400',
    owner   => 'storm',
    group   => 'storm',
    source  => '/etc/grid-security/hostkey.pem',
    require => File['/etc/grid-security/storm-webdav'],
  }

  file { '/etc/storm/webdav/sa.d/README.md':
    ensure => file,
  }
  file { '/etc/storm/webdav/sa.d/sa.properties.template':
    ensure => file,
  }

  if $storm::webdav::storage_areas_source_directory {
    file { '/etc/storm/webdav/sa.d':
      ensure  => directory,
      source  => $storm::webdav::storage_areas_source_directory,
      recurse => true,
      purge   => true,
    }
  } elsif $storm::webdav::storage_areas {
    file { '/etc/storm/webdav/sa.d':
      ensure  => directory,
      recurse => true,
      purge   => true,
    }
    $sa_properties_template_file='storm/etc/storm/webdav/sa.d/sa.properties.erb'
    $storm::webdav::storage_areas.each | $sa | {
      # define template variables
      # mandatory fields
      $name = $sa[name]
      $root_path = $sa[root_path]
      # optional fileds
      $fs_type = pick($sa[filesystem_type], 'posix')
      $access_points = pick($sa[access_points], ["/${name}"])
      $vos = pick($sa[vos], [])
      $orgs = pick($sa[orgs], [])
      $authenticated_read_enabled = pick($sa[authenticated_read_enabled], false)
      $anonymous_read_enabled = pick($sa[anonymous_read_enabled], false)
      $vo_map_enabled = pick($sa[vo_map_enabled], true)
      $vo_map_grants_write_permission = pick($sa[vo_map_grants_write_permission], false)
      $orgs_grant_read_permission = pick($sa[orgs_grant_read_permission], true)
      $orgs_grant_write_permission = pick($sa[orgs_grant_write_permission], false)
      $wlcg_scope_authz_enabled = pick($sa[wlcg_scope_authz_enabled], false)
      $fine_grained_authz_enabled = pick($sa[fine_grained_authz_enabled], false)
      # use template
      file { "/etc/storm/webdav/sa.d/${name}.properties":
        ensure  => file,
        content => template($sa_properties_template_file),
        owner   => 'root',
        group   => 'storm',
        notify  => Service['storm-webdav'],
      }
    }
  } else {
    notice('Empty storage area list. No storage area has been defined and initialized.')
  }

  if $storm::webdav::scitags_enabled {
    file { '/etc/flowd/flowd.cfg' :
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/storm/etc/storm/flowd.cfg',
    }
  }

  # Directory '/etc/systemd/system/storm-webdav.service.d' is created by rpm
  $service_dir='/etc/systemd/system/storm-webdav.service.d'

  $limit_template_file='storm/etc/systemd/system/storm-webdav.service.d/filelimit.conf.erb'
  $limit_file="${service_dir}/filelimit.conf"
  # configuration of filelimit.conf
  file { $limit_file:
    ensure  => file,
    content => template($limit_template_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => [Service['storm-webdav']],
  }

  $environment_file="${service_dir}/storm-webdav.conf"
  $environment_template_file='storm/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf.erb'
  file { $environment_file:
    ensure  => file,
    content => template($environment_template_file),
    notify  => [Service['storm-webdav']],
  }
}
