# @summary StoRM Frontend config class
#
class storm::frontend::config (

  $user_name = $storm::frontend::user_name,
  $config_dir = $storm::frontend::config_dir,

) {

  # set ownership and permissions on storm fe config dir
  file { 'fe::storm-fe-config-dir':
    ensure  => directory,
    path    => $config_dir,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0750',
    recurse => true,
  }

  $conf_file="${config_dir}/storm-frontend-server.conf"
  $conf_template_file='storm/etc/storm/frontend-server/storm-frontend-server.conf.erb'

  file { 'fe::configure-fe-conf-file':
    ensure  => present,
    path    => $conf_file,
    content => template($conf_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-server-mp'],
  }

  $sysconfig_file='/etc/sysconfig/storm-frontend-server'
  $sysconfig_template_file='storm/etc/sysconfig/storm-frontend-server.erb'
  file { 'fe::configure-sysconfig-file':
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-frontend-server'],
    require => Package['storm-frontend-server-mp'],
  }
}
