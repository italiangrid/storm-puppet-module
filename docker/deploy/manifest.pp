class { 'storm::repo':
  enabled => ['nightly'],
}

include mwdevel_test_ca
include mwdevel_test_vos

package { 'ca-policy-egi-core':
  ensure  => installed,
  require => File['egi-trust-anchors.repo'],
}

class { 'storm':
  user_name            => 'storm',
  storage_area         => [
    {
      'name'                       => 'test.vo',
      'root_path'                  => '/storage/test.vo',
      'filesystem_type'            => 'posixfs',
      'access_points'              => ['/test.vo'],
      'vos'                        => ['test.vo', 'test.vo.2'],
      'orgs'                       => [],
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
    },
    {
      'name'                       => 'test.vo.2',
      'root_path'                  => '/storage/test.vo.2',
      'filesystem_type'            => 'posixfs',
      'access_points'              => ['/test.vo.2'],
      'vos'                        => ['test.vo.2'],
      'orgs'                       => [],
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
    },
  ],
  components           => ['webdav'],
  webdav_oauth_issuers => [
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

include storm::webdav
