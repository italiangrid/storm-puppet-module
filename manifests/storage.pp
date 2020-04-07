# @summary Init testbed storage area's directories
#
# @example Example of usage
#    class { 'storm::storage':
#      storage_root => '/storage',
#      storage_areas => {
#        'test.vo' => '/storage/test.vo',
#        'tape' => '/storage/tape',
#      },
#    }
#
# @param storage_root
#
# @param storage_areas
#
class storm::storage (

  String $storage_root = '/storage',

  Hash[String, String] $storage_areas = {
    'test.vo' => '/storage/test.vo',
    'test.vo.2' => '/storage/test.vo.2',
    'igi' => '/storage/igi',
    'noauth' => '/storage/noauth',
    'test.vo.bis' => '/storage/test.vo.bis',
    'nested' => '/storage/nested',
    'tape' => '/storage/tape',
  },

) {

  file { $storage_root:
    ensure  => 'directory',
    owner   => 'storm',
    group   => 'storm',
    mode    => '0755',
    recurse => true,
  }
  $storage_areas.each | $name, $path | {
    file { $path:
      ensure  => 'directory',
      owner   => 'storm',
      group   => 'storm',
      mode    => '0755',
      recurse => true,
      require => File[$storage_root],
    }
  }
}
