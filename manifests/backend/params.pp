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

  $frontend_port = lookup('storm::backend::frontend_port', Integer, undef, 8444)

  # StoRM Service Generic Behavior
  $directory_automatic_creation = lookup('storm::backend::directory_automatic_creation', Boolean, undef, false)
  $directory_writeperm = lookup('storm::backend::directory_writeperm', Boolean, undef, false)

  # REST Services parameter
  $rest_services_port = lookup('storm::backend::rest_services_port', Integer, undef, 9998)
  $rest_services_max_threads = lookup('storm::backend::rest_services_max_threads', Integer, undef, 100)
  $rest_services_max_queue_size = lookup('storm::backend::rest_services_max_queue_size', Integer, undef, 1000)

  # XMLRPC Server parameter
  $synchcall_xmlrpc_unsecure_server_port = lookup('storm::backend::synchcall_xmlrpc_unsecure_server_port', Integer, undef, 8080)
  $synchcall_xmlrpc_maxthread = lookup('storm::backend::synchcall_xmlrpc_maxthread', Integer, undef, 256)
  $synchcall_xmlrpc_max_queue_size = lookup('storm::backend::synchcall_xmlrpc_max_queue_size', Integer, undef, 1000)
  $synchcall_xmlrpc_security_enabled = lookup('storm::backend::synchcall_xmlrpc_security_enabled', Boolean, undef, true)
  $synchcall_xmlrpc_security_token = lookup('storm::backend::synchcall_xmlrpc_security_token', String, undef, 'secret')
}
