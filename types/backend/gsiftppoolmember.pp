# @summary The GsiftpPoolMember type for storm-backend-server
type Storm::Backend::GsiftpPoolMember = Struct[{
  hostname => String,
  port     => Optional[Integer],
  weight   => Optional[Integer],
}]
