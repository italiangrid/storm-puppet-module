class { 'storm::webdav':
  user_name     => 'storm',
  user_uid      => 1100,
  user_gid      => 1100,
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
  hostnames     => ['omii006-vm03.cnaf.infn.it'],
}

class { 'storm::gridftp':
  port            => 2811,
  port_range      => '20000,25000',
  connections_max => 2000,
}
