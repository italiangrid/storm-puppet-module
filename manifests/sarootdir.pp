# @summary StoRM Storage Area root directory defined resource
define storm::sarootdir (
) {
  file { $title:
    ensure => directory,
    owner  => 'storm',
    group  => 'storm',
    mode   => '0750',
  }
}
