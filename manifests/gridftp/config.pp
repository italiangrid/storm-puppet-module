# @summary StoRM GridFTP config class
#
class storm::gridftp::config (
) {

  $conf_file='/etc/grid-security/gridftp.conf'
  if !empty($storm::gridftp::gridftp_conf_file) {
    notice("${conf_file} initialized from ${storm::gridftp::gridftp_conf_file}")
    file { $conf_file:
      ensure => present,
      source => $storm::gridftp::gridftp_conf_file,
      notify => Service['storm-globus-gridftp'],
    }
  } else {
    notice("${conf_file} initialized from internal template")
    $conf_template_file='storm/etc/grid-security/gridftp.conf.erb'
    file { $conf_file:
      ensure  => present,
      content => template($conf_template_file),
      notify  => Service['storm-globus-gridftp'],
    }
  }

  ## ensure backwards compatibility after moving conf file to /etc/grid-security/gridftp.conf
  file { '/etc/gridftp.conf':
    ensure => absent,
  }

  $sysconfig_file='/etc/sysconfig/storm-globus-gridftp'
  $sysconfig_template_file='storm/etc/sysconfig/storm-globus-gridftp.erb'

  file { $sysconfig_file:
    ensure  => present,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-globus-gridftp'],
  }
}
