# Class: storm::webdav::config
# ===========================
#
class storm::webdav::config (

  $user_name = $storm::webdav::user_name,
  $user_uid = $storm::webdav::user_uid,
  $user_gid = $storm::webdav::user_gid,

  $storage_root_dir = $storm::webdav::storage_root_dir,

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

  $log = $storm::webdav::log,
  $log_configuration = $storm::webdav::log_configuration,
  $access_log_configuration = $storm::webdav::access_log_configuration,

  $jvm_opts = $storm::webdav::jvm_opts,

  $authz_server_enable = $storm::webdav::authz_server_enable,
  $authz_server_issuer = $storm::webdav::authz_server_issuer,
  $authz_server_max_token_lifetime_sec = $storm::webdav::authz_server_max_token_lifetime_sec,
  $authz_server_secret = $storm::webdav::authz_server_secret,
  $require_client_cert = $storm::webdav::require_client_cert,

  $debug = $storm::webdav::debug,
  $debug_port = $storm::webdav::debug_port,
  $debug_suspend = $storm::webdav::debug_suspend,

) {

  storm::user { 'storm-webdav user':
    user_name => $user_name,
    user_uid  => $user_uid,
    user_gid  => $user_gid,
  }

  # storage area root path
  storm::storage_root_dir { 'check_storage_root_dir':
    path  => $storage_root_dir,
    owner => $user_name,
    group => $user_name,
  }

  file { $hostcert_dir:
    ensure  => directory,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0755',
    recurse => true,
  }

  $hostcert="${hostcert_dir}/hostcert.pem"
  $hostkey="${hostcert_dir}/hostkey.pem"

  storm::service_hostcert { 'set_dav_hostcert_hostkey':
    hostcert => $hostcert,
    hostkey  => $hostkey,
    owner    => $user_name,
    group    => $user_name,
    require  => File[$hostcert_dir],
  }

  file { $config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  file { "${config_dir}/config":
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
    require => File[$config_dir],
  }

  $webdav_sa_dir="${config_dir}/sa.d"

  file { $webdav_sa_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
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
      file { "${webdav_sa_dir}/${name}.properties":
        ensure  => present,
        content => template($sa_properties_template_file),
        owner   => $user_name,
        require => File[$webdav_sa_dir],
      }
      # check root path
      storm::storage_root_dir { "check_${name}":
        path  => $root_path,
        owner => $user_name,
        group => $user_name,
      }
    }
  }

  $application_template_file='storm/etc/storm/webdav/config/application.yml.erb'
  # configuration of application.yml
  file { "${config_dir}/config/application.yml":
    ensure  => present,
    content => template($application_template_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [File["${config_dir}/config"], Package['storm-webdav']],
  }

  $sysconfig_file='/etc/sysconfig/storm-webdav'
  $sysconfig_template_file='storm/etc/sysconfig/storm-webdav.erb'
  file { $sysconfig_file:
    ensure  => present,
    content => template($sysconfig_template_file),
  }

  case $::osfamily {

    'RedHat': {

      case $::operatingsystemmajrelease {
        '7': {
          $unit_file='/etc/systemd/system/storm-webdav.service'
          $unit_template_file='storm/etc/systemd/system/storm-webdav.service.erb'
          file { $unit_file:
            ensure  => present,
            content => template($unit_template_file),
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
