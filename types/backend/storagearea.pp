# @summary The storage area type for storm-backend-server
#
# <table>
#   <thead> <tr><th>Property</th><th>Description</th></tr> </thead>
#   <tbody>
#     <tr><td>name</td><td><b>Mandatory</b> - Storage Area's name used to initialize the default accesspoint and the VO name.</td></tr>
#   </tbody>
# </table>
#
type Storm::Backend::StorageArea = Struct[{
  name                         => String,
  root_path                    => String,
  access_points                => Optional[Array[String]],
  vos                          => Optional[Array[String]],
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
