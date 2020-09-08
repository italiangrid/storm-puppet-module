# @summary StoRM root directory defined resource
define storm::rootdir (
  String $path,
) {
  file { $path:
    ensure  => 'directory',
    owner   => 'storm',
    group   => 'storm',
    mode    => '0750',
    recurse => true,
  }
}
