# @summary Init testbed storage area's directories
#
# @example Example of usage
#    class { 'storm::storage':
#      root_directories => [
#        '/storage',
#        '/storage/disk',
#        '/storage/tape',
#      ],
#    }
#
# @param root_directories
#   A list of all storage root directories owned by storm user. You must add also all parent directories.
#
class storm::storage (

  Array[String] $root_directories = ['/storage'],

) {

  $root_directories.each | $path | {
    storm::rootdir { $path:
      path => $path,
    }
  }
}
