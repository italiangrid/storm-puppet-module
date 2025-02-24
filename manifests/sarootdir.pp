# @summary StoRM Storage Area root directory defined resource
#
# @param mode
#   The permission mask. E.g. '0750'
#
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
