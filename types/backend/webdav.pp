# @summary The WebDAV type for storm-backend-server
type Storm::Backend::Webdav = Struct[{
  pool => Array[Struct[{
    hostname => String,
    port     => Optional[Integer],
  }]],
}]
