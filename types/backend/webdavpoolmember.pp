# @summary The WebdavPoolMember type for storm-backend-server
type Storm::Backend::WebdavPoolMember = Struct[{
  hostname => String,
  http_port => Optional[Integer],
  https_port => Optional[Integer],
}]
