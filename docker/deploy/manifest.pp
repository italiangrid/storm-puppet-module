class { 'storm::repo':
  enabled => ['nightly'],
}

include mwdevel_test_ca
include mwdevel_test_vos

package { 'ca-policy-egi-core':
  ensure  => installed,
  require => File['egi-trust-anchors.repo'],
}

class { 'storm::webdav':
  storage_areas => [
    {
      'name'                       => 'test.vo',
      'root_path'                  => '/storage/test.vo',
      'access_points'              => ['/test.vo'],
      'vos'                        => ['test.vo', 'test.vo.2'],
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
      'vo_map_enabled'             => false,
    },
    {
      'name'                       => 'test.vo.2',
      'root_path'                  => '/storage/test.vo.2',
      'access_points'              => ['/test.vo.2'],
      'vos'                        => ['test.vo.2'],
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
      'vo_map_enabled'             => false,
    },
  ],
  oauth_issuers => [
    {
      name   => 'iam-virgo',
      issuer => 'https://iam-virgo.cloud.cnaf.infn.it/',
    },
    {
      name   => 'indigo-dc',
      issuer => 'https://iam-test.indigo-datacloud.eu/',
    },
  ],
}
