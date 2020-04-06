class { 'storm::users':
  groups => {
    'storm-SA-read'  => {
      gid => '990',
    },
    'storm-SA-write' => {
      gid => '989',
    },
  },
  users  => {
    'edguser' => {
      'comment' => 'Edguser user',
      'groups'  => [ 'edguser', 'storm', ],
      'uid'     => '995',
      'gid'     => '995',
    },
    'storm'   => {
      'comment' => 'StoRM user',
      'groups'  => [ 'storm', 'edguser', 'storm-SA-read', 'storm-SA-write' ],
      'uid'     => '991',
      'gid'     => '991',
    },
  },
}
