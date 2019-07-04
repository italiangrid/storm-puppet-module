type Storm::Webdav::StorageArea = Struct[{
  name                       => String,
  root_path                  => String,
  access_points              => Array[String],
  vos                        => Array[String],
  orgs                       => Optional[Array[String]],
  authenticated_read_enabled => Boolean,
  anonymous_read_enabled     => Boolean,
  vo_map_enabled             => Boolean,
  vo_map_grants_write_access => Optional[Boolean],
}]
