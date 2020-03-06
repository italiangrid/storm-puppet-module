# @summary The Rfio type for storm-backend-server
type Storm::Backend::Rfio = Struct[{
  hostname => String,
  port => Optional[Integer],
}]
