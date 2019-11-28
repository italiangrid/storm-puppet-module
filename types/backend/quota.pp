# @summary The Quota type for storm-backend-server
type Storm::Backend::Quota = Struct[{
  device => String,
  type   => Enum['username', 'group', 'fileset'],
  value  => String,
}]
