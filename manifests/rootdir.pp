# @summary StoRM main storage area root directory defined resource
define storm::rootdir (
) {
  file { $title:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
