# @summary StoRM main storage area root directory defined resource
define storm::rootdir (
  String $mode = '0755',
) {
  file { $title:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => $mode,
  }
}
