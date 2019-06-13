class { 'storm::repo':
  enabled => ['nightly'],
}

include mwdevel_test_vos

package { 'ca-policy-egi-core':
  ensure => latest,
}

class { 'storm':
  user_name    => 'storm',
  storage_area => [
    {
      'name'                       => 'test.vo',
      'root_path'                  => '/storage/test.vo',
      'filesystem_type'            => 'posixfs',
      'access_points'              => ['/test.vo'],
      'vos'                        => ['test.vo', 'test.vo.2'],
      'orgs'                       => '',
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
    },
    {
      'name'                       => 'atlas',
      'root_path'                  => '/storage/atlas',
      'filesystem_type'            => 'gpfs',
      'access_points'              => ['/atlas', '/atlasdisk'],
      'vos'                        => ['atlas'],
      'orgs'                       => '',
      'authenticated_read_enabled' => false,
      'anonymous_read_enabled'     => false,
    },
  ],
}

include storm::webdav
