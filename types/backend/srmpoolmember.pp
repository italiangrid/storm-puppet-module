# @summary The SrmPoolMember type for storm-backend-server
type Storm::Backend::SrmPoolMember = Struct[{
  hostname => String,
  port     => Optional[Integer],
}]
