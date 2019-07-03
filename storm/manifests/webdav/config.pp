# Class: storm::webdav::config
# ===========================
#
class storm::webdav::config {

  file { $storm::webdav_hostcert_dir:
    ensure  => directory,
    owner   => $storm::user_name,
    group   => $storm::user_name,
    mode    => '0755',
    recurse => true,
  }

  $webdav_hostcert_filepath="${storm::webdav_hostcert_dir}/hostcert.pem"
  $webdav_hostkey_filepath="${storm::webdav_hostcert_dir}/hostkey.pem"

  class { 'storm::service_hostcert':
    hostcert => $webdav_hostcert_filepath,
    hostkey  => $webdav_hostkey_filepath,
    owner    => $storm::user_name,
    group    => $storm::user_name,
    require  => File[$storm::webdav_hostcert_dir],
  }

  file { $storm::webdav_config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $storm::user_name,
    mode    => '0750',
    recurse => true,
  }

  file { "${storm::webdav_config_dir}/config":
    ensure  => directory,
    owner   => 'root',
    group   => $storm::user_name,
    mode    => '0750',
    recurse => true,
    require => File[$storm::webdav_config_dir],
  }

  $webdav_sa_dir="${storm::webdav_config_dir}/sa.d"

  file { $webdav_sa_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $storm::user_name,
    mode    => '0750',
    recurse => true,
  }

  if $storm::storage_areas {
    $sa_properties_template_file='storm/etc/storm/webdav/sa.d/sa.properties.erb'
    $storm::storage_areas.each | $sa | {
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
        owner   => $storm::user_name,
        require => File[$webdav_sa_dir],
      }
    }
  }

  $oauth_issuers = $storm::webdav_oauth_issuers
  $application_template_file='storm/etc/storm/webdav/config/application.yml.erb'
  # configuration of application.yml
  file { "${storm::webdav_config_dir}/config/application.yml":
    ensure  => present,
    content => template($application_template_file),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [File["${storm::webdav_config_dir}/config"], Package['storm-webdav']],
  }

  $sysconfig_template_file='storm/etc/sysconfig/storm-webdav.erb'
  file { '/etc/sysconfig/storm-webdav':
    ensure  => present,
    content => template($sysconfig_template_file),
  }
}
