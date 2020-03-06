# @summary The Xroot type for storm-backend-server
type Storm::Backend::Xroot = Struct[{
  hostname => String,
  port => Optional[Integer],
}]
