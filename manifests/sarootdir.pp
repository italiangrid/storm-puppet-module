# @summary StoRM Storage Area root directory defined resource
define storm::sarootdir (
  String $mode = '0750',
) {
  file { $title:
    ensure  => directory,
    owner   => 'storm',
    group   => 'storm',
    mode    => $mode,
    require => User['storm'],
  }
}
