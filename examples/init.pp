# The baseline for module testing used by Puppet Inc. is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://puppet.com/docs/puppet/latest/bgtm.html#testing-your-module
#
class { 'storm::webdav':
  user_name        => 'storm',
  storage_root_dir => '/storage',
  storage_areas    => [
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
  oauth_issuers    => [
    {
      name   => 'iam-virgo',
      issuer => 'https://iam-virgo.cloud.cnaf.infn.it/',
    },
    {
      name   => 'indigo-dc',
      issuer => 'https://iam-test.indigo-datacloud.eu/',
    },
  ],
  hostnames        => ['omii006-vm03.cnaf.infn.it'],
}
