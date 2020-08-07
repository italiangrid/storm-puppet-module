# StoRM puppet module

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations - OS compatibility](#limitations)

## Description

StoRM Puppet module allows administrators to easily configure StoRM services.
Currently, the supported services are:

- StoRM Backend
- StoRM Frontend
- StoRM WebDAV
- StoRM Globus GridFTP server

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

With this Puppet module, administrators can configure StoRM services. 
Some utility classes are also provided to configure users, storage directories and pool accounts, if needed.

* [StoRM Backend component](#storm-backend-component)
* [StoRM Frontend component](#storm-frontend-component)
* [StoRM WebDAV component](#storm-webdav-component)
* [StoRM GridFTP component](#storm-gridftp-component)
* [StoRM users utility class](#storm-users-utility-class)
* [StoRM storage utility class](#storm-storage-utility-class)

### StoRM Backend component

StoRM Backend class:

- installs MySQL community client/server;
- creates and initializes StoRM database;
- installs and configures storm-backend-server service;
- installs and configures storm-info-provider and bdii.

|   Property Name                 |   Description     |
|:--------------------------------|:------------------|
| `hostname` <span style="color:red">*</span> | StoRM Backend Fully Qualified Domain Name. **Mandatory**. |
| `install_native_libs_gpfs`      | Set this if you need to install storm-native-libs-gpfs. Default value: **false**. |
| `db_username`             | The name of user used to connect to local database. Default value: **storm**. |
| `db_password`             | Password for the user in `db_storm_username`. Default value: **bluemoon**. |
| `mysql_server_install` |
| `mysql_server_root_password` |
| `mysql_server_override_options` |
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

### StoRM Frontend component

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

### StoRM WebDAV component

The main StoRM WebDAV configuration parameters are:

- `storage_areas`: the list of `Storm::Webdav::StorageArea` elements (more info below).
- `oauth_issuers`: the list of `Storm::Webdav::OAuthIssuer` elements that means the supported OAuth providers (more info below).
- `hostnames`: the list of hostname and aliases supported for Third-Party-Copy.
- `http_port` and `https_port`: the service ports. Default: **8085**, **8443**.

Read more about StoRM WebDAV configuration parameters at the [online documentation](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Awebdav.html).

The [`Storm::Webdav::StorageArea`](https://italiangrid.github.io/storm-puppet-module/puppet_data_type_aliases/Storm_3A_3AWebdav_3A_3AStorageArea.html) type :

- `name`: The name of the storage area. **Required**.
- `root_path`: The path of the storage area root directory. **Required**.
- `access_points`: A list of logic path used to access storage area's root. **Required**.
- `vos`: A list of one or more Virtual Organization names of the users allowed to read/write into the storage area. **Required**.
- `orgs`: A list of one or more Organizations. Optional. Default: ''.
- `authenticated_read_enabled`: A boolean value used to enable the read of the storage area content to authenticated users. Optional. Default: `false`.
- `anonymous_read_enabled`: A boolean value used to enable anonymous read access to storage area content. Optional. Default: `false`.
- `vo_map_enabled`: A boolean value used to enable the use of the VO gridmap files. Optional. Default: `false`.
- `vo_map_grants_write_access`: A boolean value used to grant write access to the VO users read from gridmap file. Optional. Default: `false`.
- `orgs_grant_write_permission`: A boolean value used to grant write access to the members of the organizations defined with `orgs`. Optional. Default: `false`.

The [`Storm::Webdav::OAuthIssuer`](https://italiangrid.github.io/storm-puppet-module/puppet_data_type_aliases/Storm_3A_3AWebdav_3A_3AOAuthIssuer.html) type:

- `name`: the organization name. **Required**.
- `issuer`: the issuer URL. **Required**.

Example of StoRM WebDAV configuration:

```
class { 'storm::webdav':
  storage_areas => [
    {
      name                       => 'test.vo',
      root_path                  => '/storage/test.vo',
      access_points              => ['/test.vo'],
      vos                        => ['test.vo'],
    },
    {
      name                       => 'test.vo.2',
      root_path                  => '/storage/test.vo.2',
      access_points              => ['/test.vo.2'],
      vos                        => ['test.vo.2'],
      authenticated_read_enabled => true,
    },
  ],
  hostnames => ['storm-webdav.example.org', 'alias-for-storm-webdav.example.org'],
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Awebdav.html) for all WebDAV class options.

### StoRM GridFTP component

Example of StoRM Gridftp configuration:

```
class { 'storm::gridftp':
  redirect_lcmaps_log => true,
  llgt_log_file       => '/var/log/storm/storm-gridftp-lcmaps.log',
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Agridftp.html) for all GridFTP class options.

### StoRM users utility class

To create the default StoRM users and groups you can use the `storm::users` utility class.

Use:

```
include storm::users
```

to create default scenario:

- `storm` group with id 1100
- `edguser` group with id 1101
- `storm` user with id 1100, member of `storm` and `edguser` groups
- `edguser` user with id 1101, member of `edguser` and `storm` groups

You can also customize and create your own users and groups as follow:

```
class { 'storm::users':
  groups => {
    infosys => {
      gid => '996',
    },
  },
  users  => {
    edguser => {
      comment => 'Edguser user',
      groups  => [ edguser, infosys, storm, ],
      uid     => '995',
      gid     => '995',
      home    => '/home/edguser',
    },
    storm   => {
      comment => 'StoRM user',
      groups  => [ storm, edguser, ],
      uid     => '991',
      gid     => '991',
      home    => '/home/storm',
    },
  },
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Ausers.html) for all the class options.

### StoRM storage utility class

To create the root directories of your storage areas, you can use the `storm::storage` utility class.
It's mainly used for test purposes. We expected not to use this class on production.

Use:

```
include storm::storage
```

to create `/storage` directory owned by 'storm' user and '755' as permissions.
You can specify a different list of directories as follow:

```
class { 'storm::storage':
  root_directories => [
    '/storage',
    '/storage/test.vo',
    '/storage/dteam',
  ],
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Astorage.html) for all the class options.







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
