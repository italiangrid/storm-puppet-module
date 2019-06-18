# Class: storm::webdav
# ===========================
#
class storm::webdav (

  String $user_name = $storm::user_name,
  String $hostcert_dirpath = $storm::webdav_hostcert_dirpath,
  Array[Struct[{
    name                       => String,
    root_path                  => String,
    filesystem_type            => Enum['posixfs', 'gpfs'],
    access_points              => Array[String],
    vos                        => Array[String],
    orgs                       => String,
    authenticated_read_enabled => Boolean,
    anonymous_read_enabled     => Boolean,
  }]] $storage_area = $storm::storage_area,
  String $webdav_config_dirpath = $storm::webdav_config_dirpath,

) inherits storm {

  file { $hostcert_dirpath:
    ensure  => directory,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0755',
    recurse => true,
  }

  file { $webdav_config_dirpath:
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  class { 'storm::service_hostcert':
    hostcert => "${hostcert_dirpath}/hostcert.pem",
    hostkey  => "${hostcert_dirpath}/hostkey.pem",
    owner    => $user_name,
    group    => $user_name,
  }

  file { '/etc/storm/webdav/sa.d':
    ensure  => directory,
    owner   => 'root',
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  if $storage_area {
    $storage_area.each | $sa | {
      $name = $sa[name]
      $root_path = $sa[root_path]
      $filesystem_type = $sa[filesystem_type]
      $access_points = $sa[access_points]
      $vos = $sa[vos]
      $orgs = $sa[orgs]
      $authenticated_read_enabled = $sa[authenticated_read_enabled]
      $anonymous_read_enabled = $sa[anonymous_read_enabled]
      file { "/etc/storm/webdav/sa.d/${name}.properties":
        ensure  => present,
        content => epp('storm/sa.properties.epp',
          {
            'name'                       => $name,
            'root_path'                  => $root_path,
            'filesystem_type'            => $filesystem_type,
            'access_points'              => $access_points,
            'vos'                        => $vos,
            'orgs'                       => $orgs,
            'authenticated_read_enabled' => $authenticated_read_enabled,
            'anonymous_read_enabled'     => $anonymous_read_enabled,
          }
        ),
        owner   => $user_name,
        require => File['/etc/storm/webdav/sa.d'],
      }
    }
  }

  package { 'storm-webdav':
    ensure => installed,
  }

  service { 'storm-webdav':
    ensure  => running,
    enable  => true,
    require => Package['storm-webdav'],
  }
}
