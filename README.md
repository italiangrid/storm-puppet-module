# StoRM puppet module

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations - OS compatibility](#limitations)

## Description

StoRM Puppet module allows administrators to easily configure StoRM services.
Currently, the supported services are:

- StoRM WebDAV
- StoRM Globus GridFTP server
- StoRM Frontend
- StoRM Backend

## Setup

StoRM Puppet module is available on puppet forge:

```
puppet module install cnafsd-storm
```

You can also build and install module from source code as follow:

```
git clone https://github.com/italiangrid/storm-puppet-module.git
cd storm-puppet-module
puppet module build
puppet module install ./pkg/cnafsd-storm-*.tar.gz
```

## Usage

With this Puppet module, administrators can configure StoRM services, users and storage directories if needed.

### Customize StoRM users

To create the default StoRM users and groups use `storm::users` class.

Use:

```
class { 'storm::users': }
```

to create default scenario:

- `storm` group with id 991
- `edguser` group with id 995
- `infosys` group with id 996
- `storm` user with id 991, member of `storm` and `edguser` groups
- `edguser` user with id 995

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Ausers.html) for all the class options.

### Customize StoRM WebDAV component

Example of StoRM WebDAV configuration:

```
class { 'storm::webdav':
  storage_areas => [
    {
      name                       => 'test.vo',
      root_path                  => '/storage/test.vo',
      access_points              => ['/test.vo'],
      vos                        => ['test.vo'],
      authenticated_read_enabled => false,
      anonymous_read_enabled     => false,
      vo_map_enabled             => false,
    },
    {
      name                       => 'test.vo.2',
      root_path                  => '/storage/test.vo.2',
      access_points              => ['/test.vo.2'],
      vos                        => ['test.vo.2'],
      authenticated_read_enabled => true,
      anonymous_read_enabled     => false,
      vo_map_enabled             => false,
    },
  ],
  hostnames => ['storm-webdav.example.org', 'alias-for-storm-webdav.example.org'],
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Awebdav.html) for all WebDAV class options.

### Customize StoRM GridFTP component

Example of StoRM Gridftp configuration:

```
class { 'storm::gridftp':
  redirect_lcmaps_log => true,
  llgt_log_file       => '/var/log/storm/storm-gridftp-lcmaps.log',
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Agridftp.html) for all GridFTP class options.

### Customize StoRM Frontend component

Example of StoRM Frontend configuration:

```
class { 'storm::frontend':
  be_xmlrpc_host  => 'storm-backend.example',
  be_xmlrpc_token => 'secret',
  db_host         => 'storm-backend.example',
  db_user         => 'storm',
  db_passwd       => 'secret',
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Afrontend.html) for all Frontend class options.

### Customize StoRM Backend component

StoRM Backend class:

- installs MySQL community client/server;
- creates and initializes StoRM database;
- installs and configures storm-backend-server service;
- installs and configures storm-info-provider and bdii.

|   Property Name                 |   Description     |
|:--------------------------------|:------------------|
| `hostname` <span style="color:red">*</span> | StoRM Backend Fully Qualified Domain Name. **Mandatory**. |
| `install_native_libs_gpfs`      | Set this if you need to install storm-native-libs-gpfs. Default value: **false**. |
| `db_root_password`              | MySQL root user password. Default value: **storm** |
| `db_storm_username`             | The name of user used to connect to local database. Default value: **storm**. |
| `db_storm_password`             | Password for the user in `db_storm_username`. Default value: **bluemoon**. |
| `xroot_hostname`                | Root server (default value for all Storage Areas). Note: you may change the settings for each SA acting on its configuration. Default value: `hostname`|
| `xroot_port`                    | Root server port (default value for all Storage Areas). Default value: **1094**|
| `gsiftp_pool_balance_strategy`  | |
| `gsiftp_pool_members`           | |
| `webdav_pool_members`           | |
| `srm_pool_members`              | |
| `transfer_protocols`            | |
| `fs_type`                       | |
| `storage_areas` | |
| `frontend_public_host` | |
| `frontend_port` | |
| `directory_automatic_creation` | |
| `directory_writeperm` | |
| `rest_services_port` | |
| `rest_services_max_threads` | |
| `rest_services_max_queue_size` | |
| `synchcall_xmlrpc_unsecure_server_port` | |
| `synchcall_xmlrpc_maxthread` | |
| `synchcall_xmlrpc_max_queue_size` | |
| `synchcall_xmlrpc_security_enabled` | |
| `synchcall_xmlrpc_security_token` | |
| `ptg_skip_acl_setup` | |
| `pinlifetime_default` | |
| `pinlifetime_maximum` | |
| `sanity_check_enabled` | |
| `service_du_enabled` | |
| `service_du_delay` | |
| `service_du_interval` | |
| `synchcall_max_ls_entries` | |
| `gc_pinnedfiles_cleaning_delay` | |
| `gc_pinnedfiles_cleaning_interval` | |
| `gc_purge_enabled` | |
| `gc_purge_interval` | |
| `gc_purge_size` | |
| `gc_expired_request_time` | |
| `gc_expired_inprogress_time` | |
| `gc_ptp_transit_interval` | |
| `gc_ptp_transit_start_delay` | |
| `extraslashes_file` | |
| `extraslashes_root` | |
| `extraslashes_gsiftp` | |
| `db_connection_pool_enabled` | |
| `db_connection_pool_max_active` | |
| `db_connection_pool_max_wait` | |
| `asynch_db_reconnect_period` | |
| `asynch_db_delay_period` | |
| `asynch_picking_initial_delay` | |
| `asynch_picking_time_interval` | |
| `asynch_picking_max_batch_size` | |
| `requests_scheduler_core_size` | |
| `requests_scheduler_max_size` | |
| `requests_scheduler_queue_size` | |
| `ptp_requests_scheduler_core_size` | |
| `ptp_requests_scheduler_max_size` | |
| `ptp_requests_scheduler_queue_size` | |
| `ptg_requests_scheduler_core_size` | |
| `ptg_requests_scheduler_max_size` | |
| `ptg_requests_scheduler_queue_size` | |
| `bol_requests_scheduler_core_size` | |
| `bol_requests_scheduler_max_size` | |
| `bol_requests_scheduler_queue_size` | |
| `info_sitename` | |
| `info_storage_default_root` | |
| `info_endpoint_quality_level` | |
| `info_webdav_pool_list` | |
| `info_frontend_host_list` | |


Example of StoRM Backend configuration:

```
class { 'storm::backend':
  hostname => 'backend.test.example',
  db_root_password  => 'storm',
  db_storm_password => 'bluemoon',
  srm_pool_members => [
    {
      'hostname' => 'frontend.test.example',
    }
  ],
  gsiftp_pool_members => [
    {
      'hostname' => 'gridftp.test.example',
    },
  ],
  webdav_pool_members => [
    {
      'hostname' => 'webdav.test.example',
    },
  ],
  storage_areas => [
    {
      'name'               => 'test.vo',
      'root_path'          => '/storage/test.vo',
      'access_points'      => ['/test.vo'],
      'vos'                => ['test.vo'],
      'storage_class'      => 'T0D1',
      'online_size'        => 4,
      'transfer_protocols' => ['file', 'gsiftp', 'https'],
    },
  ],
}
```

## Documentation

You can find all the info about module classes and parameters at:

- [REFERENCE.md](https://github.com/italiangrid/storm-puppet-module/blob/master/REFERENCE.md)
- [StoRM Puppet module gh-pages site doc](https://italiangrid.github.io/storm-puppet-module)

### How to update doc

Update `REFERENCE.md` file as follow:

```
puppet strings generate --format markdown
```

Update `gh-pages` branch as follow:

```
bundle exec rake strings:gh_pages:update
```

## Limitations

It works only on RedHat CentOS 7 distribution.
