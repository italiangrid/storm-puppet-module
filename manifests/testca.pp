# @summary Utility class for internal test purpose. Install test ca repo and package.
#
class storm::testca {

  file { 'test-ca.repo':
    ensure => file,
    path   => '/etc/yum.repos.d/test-ca.repo',
    source => 'puppet:///modules/storm/test-ca.repo',
    mode   => '0644',
  }

  package {
    'igi-test-ca':
      ensure  => latest,
      require => File['test-ca.repo'],;

    'igi-test-ca-2':
      ensure  => latest,
      require => File['test-ca.repo'],;

    'igi-test-ca-256':
      ensure  => latest,
      require => File['test-ca.repo'],;
  }
}
