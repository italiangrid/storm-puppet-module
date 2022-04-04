# @summary StoRM Backend config class
#
class storm::backend::config (

  $hostname = $storm::backend::hostname,

  $install_native_libs_gpfs = $storm::backend::install_native_libs_gpfs,

  $db_hostname = $storm::backend::db_hostname,
  $db_username = $storm::backend::db_username,
  $db_password = $storm::backend::db_password,

  $xroot_hostname = $storm::backend::xroot_hostname,
  $xroot_port = $storm::backend::xroot_port,

  $gsiftp_pool_members = $storm::backend::gsiftp_pool_members,
  $gsiftp_pool_balance_strategy = $storm::backend::gsiftp_pool_balance_strategy,
  $webdav_pool_members = $storm::backend::webdav_pool_members,
  $webdav_pool_balance_strategy = $storm::backend::webdav_pool_balance_strategy,
  $srm_pool_members = $storm::backend::srm_pool_members,
  $transfer_protocols = $storm::backend::transfer_protocols,
  $fs_type = $storm::backend::fs_type,

  $storage_areas = $storm::backend::storage_areas,

  $frontend_public_host = $storm::backend::frontend_public_host,
  $frontend_port = $storm::backend::frontend_port,

  $directory_automatic_creation = $storm::backend::directory_automatic_creation,
  $directory_writeperm = $storm::backend::directory_writeperm,

  $rest_services_port = $storm::backend::rest_services_port,
  $rest_services_max_threads = $storm::backend::rest_services_max_threads,
  $rest_services_max_queue_size = $storm::backend::rest_services_max_queue_size,

  $xmlrpc_unsecure_server_port = $storm::backend::xmlrpc_unsecure_server_port,
  $xmlrpc_maxthread = $storm::backend::xmlrpc_maxthread,
  $xmlrpc_max_queue_size = $storm::backend::xmlrpc_max_queue_size,
  $xmlrpc_security_enabled = $storm::backend::xmlrpc_security_enabled,
  $xmlrpc_security_token = $storm::backend::xmlrpc_security_token,

  $ptg_skip_acl_setup = $storm::backend::ptg_skip_acl_setup,

  $pinlifetime_default = $storm::backend::pinlifetime_default,
  $pinlifetime_maximum = $storm::backend::pinlifetime_maximum,

  $sanity_check_enabled = $storm::backend::sanity_check_enabled,

  $service_du_enabled = $storm::backend::service_du_enabled,
  $service_du_delay = $storm::backend::service_du_delay,
  $service_du_interval = $storm::backend::service_du_interval,

  $max_ls_entries = $storm::backend::max_ls_entries,

  $gc_pinnedfiles_cleaning_delay = $storm::backend::gc_pinnedfiles_cleaning_delay,
  $gc_pinnedfiles_cleaning_interval = $storm::backend::gc_pinnedfiles_cleaning_interval,

  $gc_purge_enabled = $storm::backend::gc_purge_enabled,
  $gc_purge_interval = $storm::backend::gc_purge_interval,
  $gc_purge_size = $storm::backend::gc_purge_size,
  $gc_expired_request_time = $storm::backend::gc_expired_request_time,
  $gc_expired_inprogress_time = $storm::backend::gc_expired_inprogress_time,
  $gc_ptp_transit_interval = $storm::backend::gc_ptp_transit_interval,
  $gc_ptp_transit_start_delay = $storm::backend::gc_ptp_transit_start_delay,

  $extraslashes_file = $storm::backend::extraslashes_file,
  $extraslashes_root = $storm::backend::extraslashes_root,
  $extraslashes_gsiftp = $storm::backend::extraslashes_gsiftp,

  $db_connection_pool_enabled = $storm::backend::db_connection_pool_enabled,
  $db_connection_pool_max_active = $storm::backend::db_connection_pool_max_active,
  $db_connection_pool_max_wait = $storm::backend::db_connection_pool_max_wait,

  $asynch_db_reconnect_period = $storm::backend::asynch_db_reconnect_period,
  $asynch_db_delay_period = $storm::backend::asynch_db_delay_period,
  $asynch_picking_initial_delay = $storm::backend::asynch_picking_initial_delay,
  $asynch_picking_time_interval = $storm::backend::asynch_picking_time_interval,
  $asynch_picking_max_batch_size = $storm::backend::asynch_picking_max_batch_size,

  $requests_scheduler_core_size = $storm::backend::requests_scheduler_core_size,
  $requests_scheduler_max_size = $storm::backend::requests_scheduler_max_size,
  $requests_scheduler_queue_size = $storm::backend::requests_scheduler_queue_size,
  $ptp_requests_scheduler_core_size = $storm::backend::ptp_requests_scheduler_core_size,
  $ptp_requests_scheduler_max_size = $storm::backend::ptp_requests_scheduler_max_size,
  $ptp_requests_scheduler_queue_size = $storm::backend::ptp_requests_scheduler_queue_size,
  $ptg_requests_scheduler_core_size = $storm::backend::ptg_requests_scheduler_core_size,
  $ptg_requests_scheduler_max_size = $storm::backend::ptg_requests_scheduler_max_size,
  $ptg_requests_scheduler_queue_size = $storm::backend::ptg_requests_scheduler_queue_size,
  $bol_requests_scheduler_core_size = $storm::backend::bol_requests_scheduler_core_size,
  $bol_requests_scheduler_max_size = $storm::backend::bol_requests_scheduler_max_size,
  $bol_requests_scheduler_queue_size = $storm::backend::bol_requests_scheduler_queue_size,

  $info_config_file = $storm::backend::info_config_file,
  $info_sitename = $storm::backend::info_sitename,
  $info_storage_default_root = $storm::backend::info_storage_default_root,
  $info_endpoint_quality_level = $storm::backend::info_endpoint_quality_level,

  $jvm_options = $storm::backend::jvm_options,

  $jmx = $storm::backend::jmx,
  $jmx_options = $storm::backend::jmx_options,

  $debug = $storm::backend::debug,
  $debug_port = $storm::backend::debug_port,
  $debug_suspend = $storm::backend::debug_suspend,

  $lcmaps_db_file = $storm::backend::lcmaps_db_file,
  $lcmaps_policy_name = $storm::backend::lcmaps_policy_name,
  $lcmaps_log_file = $storm::backend::lcmaps_log_file,
  $lcmaps_debug_level = $storm::backend::lcmaps_debug_level,

  $http_turl_prefix = $storm::backend::http_turl_prefix,

  $storm_limit_nofile = $storm::backend::storm_limit_nofile,

  $manage_path_authz_db = $storm::backend::manage_path_authz_db,
  $path_authz_db_file = $storm::backend::path_authz_db_file,

) {

  # Service's host credentials directory
  if !defined(File['/etc/grid-security/storm']) {
    file { '/etc/grid-security/storm':
      ensure  => directory,
      owner   => 'storm',
      group   => 'storm',
      mode    => '0755',
      recurse => true,
    }
    # Service's hostcert
    file { '/etc/grid-security/storm/hostcert.pem':
      ensure  => present,
      mode    => '0644',
      owner   => 'storm',
      group   => 'storm',
      source  => '/etc/grid-security/hostcert.pem',
      require => File['/etc/grid-security/storm'],
    }
    # Service's hostkey
    file { '/etc/grid-security/storm/hostkey.pem':
      ensure  => present,
      mode    => '0400',
      owner   => 'storm',
      group   => 'storm',
      source  => '/etc/grid-security/hostkey.pem',
      require => File['/etc/grid-security/storm'],
    }
  }

  $namespace_file='/etc/storm/backend-server/namespace.xml'
  $properties_file='/etc/storm/backend-server/storm.properties'

  $namespace_template_file='storm/etc/storm/backend-server/namespace.xml.erb'

  file { $namespace_file:
    ensure  => present,
    content => template($namespace_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => [Service['storm-backend-server']],
  }

  $properties_template_file='storm/etc/storm/backend-server/storm.properties.erb'

  file { $properties_file:
    ensure  => present,
    content => template($properties_template_file),
    owner   => 'root',
    group   => 'storm',
    notify  => [Service['storm-backend-server']],
  }

  # Directory '/etc/systemd/system/storm-backend-server.service.d' is created by rpm
  $service_dir='/etc/systemd/system/storm-backend-server.service.d'

  # service conf file
  $service_file="${service_dir}/storm-backend-server.conf"
  $service_template_file='storm/etc/systemd/system/storm-backend-server.service.d/storm-backend-server.conf.erb'

  file { $service_file:
    ensure  => present,
    content => template($service_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => [Service['storm-backend-server']],
  }

  # limit conf file
  $limit_file="${service_dir}/filelimit.conf"
  $limit_template_file='storm/etc/systemd/system/storm-backend-server.service.d/filelimit.conf.erb'

  file { $limit_file:
    ensure  => present,
    content => template($limit_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => [Service['storm-backend-server']],
  }

  $info_yaim_template_file='storm/etc/storm/info-provider/storm-yaim-variables.conf.erb'

  file { $info_config_file:
    ensure  => present,
    content => template($info_yaim_template_file),
    mode    => '0644',
    owner   => 'root',
    group   => 'storm',
    notify  => [Exec['configure-info-provider']],
  }

  if $manage_path_authz_db {
    # StoRM Backend's path-authz.db file
    file { '/etc/storm/backend-server/path-authz.db':
      ensure => present,
      mode   => '0644',
      owner  => 'root',
      group  => 'storm',
      source => $path_authz_db_file,
      notify => [Service['storm-backend-server']],
    }
  }
}
