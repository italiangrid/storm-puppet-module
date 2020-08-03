# @summary The storage area type for storm-backend-server
# Mandatory fields:
# <ul><li>name</li><li>root_path</li><li>online_size</li></ul>
#
# <table>
#   <thead>
#     <tr><th>Property Name</th><th>Description</th></tr>
#   </thead>
#   <tbody>
#     <tr><td>name</td><td>The name of the storage area. Mandatory.</td></tr>
#     <tr><td>root_path</td><td>The absolute real path of the storage area parent directory. Mandatory.</td></tr>
#     <tr><td>access_points</td><td>List of relative logical paths used to access storage area. Optional variable. Default value: /{name}.</td></tr>
#   </tbody>
# </table>
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
}]
