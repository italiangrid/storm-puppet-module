# Class: storm::webdav::config
# ===========================
#
class storm::webdav::config (

  $user_name = $storm::params::user_name,
  $storage_area = $storm::webdav::params::storage_area,

) inherits storm::params {

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
      file { "/etc/storm/webdav/sa.d/${name}.properties":
        ensure => present,
      }
    }
  }
}
