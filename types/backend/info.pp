type Storm::Backend::Info = Struct[{
  sitename => Optional[String],
  backend_hostname => Optional[String],
  storage_default_root => Optional[String],
  frontend_public_host => Optional[String],
  frontend_path => Optional[String],
  frontend_port => Optional[Integer],
  rest_services_port => Optional[Integer],
  endpoint_quality_level => Optional[Integer],
  webdav_pool_list => Optional[String],
  frontend_host_list => Optional[String],
}]
