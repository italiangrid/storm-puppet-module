# @summary StoRM WebDAV config class
#
class storm::webdav::config (

  $storage_root_dir = $storm::webdav::storage_root_dir,
  $log_dir = "${storm::webdav::log_dir}/webdav",

  $storage_areas = $storm::webdav::storage_areas,

  $config_dir = $storm::webdav::config_dir,
  $hostcert_dir = $storm::webdav::hostcert_dir,
  $oauth_issuers = $storm::webdav::oauth_issuers,
  $hostnames = $storm::webdav::hostnames,

  $http_port = $storm::webdav::http_port,
  $https_port = $storm::webdav::https_port,

  $trust_anchors_dir = $storm::webdav::trust_anchors_dir,
  $trust_anchors_refresh_interval = $storm::webdav::trust_anchors_refresh_interval,

  $max_concurrent_connections = $storm::webdav::max_concurrent_connections,
  $max_queue_size = $storm::webdav::max_queue_size,
  $connector_max_idle_time = $storm::webdav::connector_max_idle_time,

  $vo_map_files_enable = $storm::webdav::vo_map_files_enable,
  $vo_map_files_config_dir = $storm::webdav::vo_map_files_config_dir,
  $vo_map_files_refresh_interval = $storm::webdav::vo_map_files_refresh_interval,

  $tpc_max_connections = $storm::webdav::tpc_max_connections,
  $tpc_verify_checksum = $storm::webdav::tpc_verify_checksum,

  $jvm_xms = $storm::webdav::jvm_xms,
  $jvm_xmx = $storm::webdav::jvm_xmx,
  $jvm_tmpdir = $storm::webdav::jvm_tmpdir,

  $authz_server_enable = $storm::webdav::authz_server_enable,
  $authz_server_issuer = $storm::webdav::authz_server_issuer,
  $authz_server_max_token_lifetime_sec = $storm::webdav::authz_server_max_token_lifetime_sec,
  $authz_server_secret = $storm::webdav::authz_server_secret,
  $require_client_cert = $storm::webdav::require_client_cert,

  $use_conscrypt = $storm::webdav::params::use_conscrypt,
  $tpc_use_conscrypt = $storm::webdav::params::tpc_use_conscrypt,
  $enable_http2 = $storm::webdav::params::enable_http2,

  $debug = $storm::webdav::debug,
  $debug_port = $storm::webdav::debug_port,
  $debug_suspend = $storm::webdav::debug_suspend,

) {

  # storage area root path
  storm::storage_root_dir { 'dav::storage-root-dir':
    path  => $storage_root_dir,
    owner => 'storm',
    group => 'storm',
  }

  # log directory
  file { 'dav::storm-log-dir':
    ensure  => directory,
    path    => $log_dir,
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }

  file { 'dav::hostcert-dir':
    ensure  => directory,
    path    => $hostcert_dir,
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }

  file { 'dav::jvm-java-tmpdir':
    ensure  => directory,
    path    => $jvm_tmpdir,
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }

  storm::service_hostcert { 'dav::host-credentials':
    hostcert => "${hostcert_dir}/hostcert.pem",
    hostkey  => "${hostcert_dir}/hostkey.pem",
    owner    => 'storm',
    group    => 'storm',
    require  => File['dav::hostcert-dir'],
  }

  file { 'dav::storm-webdav-config-dir':
    ensure  => directory,
    path    => $config_dir,
    owner   => 'root',
    group   => 'storm',
    mode    => '0750',
    recurse => true,
  }

  file { 'dav::storm-webdav-app-config-dir':
    ensure  => directory,
    path    => "${config_dir}/config",
    owner   => 'root',
    group   => 'storm',
    mode    => '0750',
    recurse => true,
    require => File['dav::storm-webdav-config-dir'],
  }

  file { 'dav::storm-webdav-sa-config-dir':
    ensure  => directory,
    path    => "${config_dir}/sa.d",
    owner   => 'root',
    group   => 'storm',
    mode    => '0750',
    recurse => true,
    require => File['dav::storm-webdav-config-dir'],
  }

  if $storage_areas {
    $sa_properties_template_file='storm/etc/storm/webdav/sa.d/sa.properties.erb'
    $storage_areas.each | $sa | {
      # define template variables
      $name = $sa[name]
      $root_path = $sa[root_path]
      $access_points = $sa[access_points]
      $vos = $sa[vos]
      $orgs = $sa[orgs]
      $authenticated_read_enabled = $sa[authenticated_read_enabled]
      $anonymous_read_enabled = $sa[anonymous_read_enabled]
      $vo_map_enabled = $sa[vo_map_enabled]
      $vo_map_grants_write_access = $sa[vo_map_grants_write_access]
      # use template
      file { "dav::create-${name}-sa-properties-file":
        ensure  => present,
        path    => "${config_dir}/sa.d/${name}.properties",
        content => template($sa_properties_template_file),
        owner   => 'storm',
        require => [File['dav::storm-webdav-sa-config-dir'], Package['storm-webdav']],
        notify  => Service['storm-webdav'],
      }
      # check root path
      storm::storage_root_dir { "dav::check-${name}-sa-root-dir":
        path  => $root_path,
        owner => 'storm',
        group => 'storm',
      }
    }
  }

  $application_template_file='storm/etc/storm/webdav/config/application.yml.erb'
  # configuration of application.yml
  file { 'dav::configure-application-yml':
    ensure  => present,
    path    => "${config_dir}/config/application.yml",
    content => template($application_template_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [File['dav::storm-webdav-app-config-dir'], Package['storm-webdav']],
    notify  => Service['storm-webdav'],
  }

  $sysconfig_file='/etc/sysconfig/storm-webdav'
  $sysconfig_template_file='storm/etc/sysconfig/storm-webdav.erb'
  file { 'dav::configure-sysconfig-file':
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-webdav'],
    require => [File['dav::jvm-java-tmpdir'], Package['storm-webdav']],
  }

  case $::osfamily {

    'RedHat': {

      case $::operatingsystemmajrelease {
        '7': {
          $unit_file='/etc/systemd/system/storm-webdav.service'
          $unit_template_file='storm/etc/systemd/system/storm-webdav.service.erb'
          file { 'dav::configure-unit-file':
            ensure  => present,
            path    => $unit_file,
            content => template($unit_template_file),
            notify  => Service['storm-webdav'],
            require => [File['dav::configure-sysconfig-file'], Package['storm-webdav']],
          }
        }
        default: {
          # nothing to do
        }
      }
    }

    # In any other case raise error:
    default: {
      fail("StoRM module not supported on ${::osfamily}/${::operatingsystem}.")
    }
  }
}
