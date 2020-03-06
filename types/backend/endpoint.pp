# @summary The Endpoint type for storm-backend-server
type Storm::Backend::Endpoint = Struct[{
  schema   => Enum['rfio','xroot','gsiftp','srm','http','https'],
  hostname => String,
  port     => Integer,
  path     => String,
}]
