# @summary StoRM Frontend params class
#
class storm::backend::params (
) inherits storm::params {

  $db_user = lookup('storm::backend::db::user', String, undef, 'storm')
  $db_passwd = lookup('storm::backend::db::passwd', String, undef, 'storm')

  $rfio_port = lookup('storm::backend::rfio_port', Integer, undef, 5001)
  $xroot_port = lookup('storm::backend::xroot_port', Integer, undef, 1094)

  $gsiftp_pool_balance_strategy = lookup('storm::backend::gsiftp_pool_balance_strategy',
    Storm::Backend::BalanceStrategy, undef, 'round-robin')

  $gsiftp_pool_members = lookup('storm::backend::gsiftp_pool_members',
    Array[Storm::Backend::GsiftpPoolMember], undef, [])

  $webdav_pool_members = lookup('storm::backend::webdav_pool_members',
    Array[Storm::Backend::WebdavPoolMember], undef, [])

  $srm_pool_members = lookup('storm::backend::srm_pool_members',
    Array[Storm::Backend::SrmPoolMember], undef, [])

  $storage_areas = lookup('storm::backend::storage_areas', Array[Storm::Backend::StorageArea], undef, [])
}
