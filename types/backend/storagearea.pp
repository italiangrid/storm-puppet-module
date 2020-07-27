# @summary The storage area type for storm-backend-server
# Mandatory fields: name, root_path, online_size
# |   Property Name   |   Description     |
# |:------------------|:------------------|
# | name              | The name of the storage area. Mandatory. |
# | root_path         | The absolute real path of the storage area parent directory. Mandatory. |
# | access_points     | List of relative logical paths used to access storage area. Optional variable. Default value: /`name`. |
type Storm::Backend::StorageArea = Struct[{
  name                         => String,
  root_path                    => String,
  access_points                => Array[String],
  vos                          => Array[String],
  fs_type                      => Optional[Storm::Backend::FsType],
  space_token                  => Optional[String],
  authz                        => Optional[String],
  storage_class                => Optional[Storm::Backend::StorageClass],
  online_size                  => Integer,
  nearline_size                => Optional[Integer],
  acl_mode                     => Optional[Storm::Backend::AclMode],
  default_acl_list             => Optional[Array[Storm::Backend::Acl]],
  quota                        => Optional[Storm::Backend::Quota],
  dn_regex                     => Optional[String],
  anonymous_http_read          => Optional[Boolean],
  transfer_protocols           => Optional[Array[Storm::Backend::TransferProtocol]],
  rfio_hostname                => Optional[String],
  rfio_port                    => Optional[Integer],
  xroot_hostname               => Optional[String],
  xroot_port                   => Optional[Integer],
  gsiftp_pool_balance_strategy => Optional[Storm::Backend::BalanceStrategy],
  gsiftp_pool_members          => Optional[Array[Storm::Backend::GsiftpPoolMember]],
  webdav_pool_members          => Optional[Array[Storm::Backend::WebdavPoolMember]],
  use_gpfs_preallocation       => Optional[Boolean],
}]
