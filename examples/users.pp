class { 'storm::users':
  groups => {
    infosys => {
      gid => '996',
    },
  },
  users  => {
    edguser => {
      comment => 'Edguser user',
      groups  => [ edguser, infosys, storm, ],
      uid     => '995',
      gid     => '995',
      home    => '/home/edguser',
    },
    storm   => {
      comment => 'StoRM user',
      groups  => [ storm, edguser, ],
      uid     => '991',
      gid     => '991',
      home    => '/home/storm',
    },
  },
}
