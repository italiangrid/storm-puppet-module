class { 'storm::users': }
-> class { 'storm::storage': }
-> class { 'storm::webdav':
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
  use_conscrypt => true,
  enable_http2  => true,
  hostnames     => ['webdav.test.example'],
}
-> class { 'storm::gridftp':
  port                => 2811,
  port_range          => '20000,25000',
  connections_max     => 2000,
  redirect_lcmaps_log => true,
  llgt_log_file       => '/var/log/storm/lcmaps.log',
}
-> class { 'storm::frontend':
  be_xmlrpc_host  => 'backend.test.example',
  be_xmlrpc_token => 'secret',
  db_host         => 'backend.test.example',
  db_user         => 'storm',
  db_passwd       => 'secret',
}
