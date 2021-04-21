# @summary The WebdavPoolMember type for storm-backend-server
#
# Since v4.0.0, the `hidden` optional parameter has been renamed to `published`.
# Its meaning is now the opposite: a value of true means that the endpoint is published by info provider.
# Default value is true.
type Storm::Backend::WebdavPoolMember = Struct[{
  hostname => String,
  http_port => Optional[Integer],
  https_port => Optional[Integer],
  published => Optional[Boolean],
}]
