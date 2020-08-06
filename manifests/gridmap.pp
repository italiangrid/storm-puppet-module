# @summary Utility class used to create gridmap dir, grid-mapfile, groupmapfile and pool accounts
#
class storm::gridmap (

  String $gridmapdir_owner = 'storm',
  String $gridmapdir_group = 'storm',
  String $gridmapdir_mode = '0770',

  Array[Data] $gridmap_data = [{
    'vo' => 'test.vo',
    'group' => 'testvo',
    'gid' => 7100,
    'pool_name' => 'tstvo',
    'pool_size' => 20,
    'pool_base_uid' => 7100,
  },{
    'vo' => 'test.vo.2',
    'group' => 'testvodue',
    'gid' => 8100,
    'pool_name' => 'testdue',
    'pool_size' => 20,
    'pool_base_uid' => 8100,
  }],

) {

  $gridmap_dir = '/etc/grid-security/gridmapdir'

  if !defined(File[$gridmap_dir]) {
    file { $gridmap_dir:
      ensure  => directory,
      owner   => $gridmapdir_owner,
      group   => $gridmapdir_group,
      mode    => $gridmapdir_mode,
      recurse => true,
      require => [User[$gridmapdir_owner]],
    }
  }

  $gridmap_data.each | $g | {

    group { $g['group']:
      ensure => present,
      gid    => $g['gid'],
    }

    range('1', $g['pool_size']).each | $id | {

      $id_str = sprintf('%03d', $id)
      $name = "${g['pool_name']}${id_str}"

      user { $name:
        ensure     => present,
        uid        => $g['pool_base_uid'] + $id,
        gid        => $g['gid'],
        groups     => [$g['group']],
        comment    => "Mapped user for ${g['vo']}",
        managehome => true,
        require    => [Group[$g['group']]],
      }

      file { "${gridmap_dir}/${name}":
        ensure  => present,
        require => File[$gridmap_dir],
        owner   => $gridmapdir_owner,
        group   => $gridmapdir_group,
      }
    }
  }

  $gridmapfile='/etc/grid-security/grid-mapfile'
  $gridmapfile_template='storm/etc/grid-security/grid-mapfile.erb'

  file { $gridmapfile:
    ensure  => present,
    content => template($gridmapfile_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  $groupmapfile='/etc/grid-security/groupmapfile'
  $groupmapfile_template='storm/etc/grid-security/groupmapfile.erb'

  file { $groupmapfile:
    ensure  => present,
    content => template($groupmapfile_template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
