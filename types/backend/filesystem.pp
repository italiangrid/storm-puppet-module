# @summary The FileSystem type for storm-backend-server
type Storm::Backend::FileSystem = Struct[{
  type => Enum['ext3', 'gpfs'],
  driver => Enum['posixfs', 'gpfs', 'test'],
  space_system => Optional[Enum['MockSpaceSystem', 'GPFSSpaceSystem']],
}]
