# @summary The ACL type for storm-backend-server
type Storm::Backend::Acl = Struct[{
  group => String,
  permission => Enum['R', 'W', 'RW'],
}]
