# @summary StoRM GridFTP config class
#
class storm::gridftp::config (

) {
  $conf_file='/etc/grid-security/gridftp.conf'
  $conf_template_file='storm/etc/grid-security/gridftp.conf.erb'

  file { $conf_file:
    ensure  => file,
    content => template($conf_template_file),
    notify  => Service['storm-globus-gridftp'],
  }

  ## ensure backwards compatibility after moving conf file to /etc/grid-security/gridftp.conf
  file { '/etc/gridftp.conf':
    ensure => absent,
  }

  $sysconfig_file='/etc/sysconfig/storm-globus-gridftp'
  $sysconfig_template_file='storm/etc/sysconfig/storm-globus-gridftp.erb'

  file { $sysconfig_file:
    ensure  => file,
    path    => $sysconfig_file,
    content => template($sysconfig_template_file),
    notify  => Service['storm-globus-gridftp'],
  }
}
