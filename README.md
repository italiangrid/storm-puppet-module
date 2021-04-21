# StoRM puppet module

#### Table of Contents

* [Description](#description)
* [Setup](#setup)
* [Usage](#usage)
  * [StoRM Backend class](#storm-backend-class)
  * [StoRM Frontend class](#storm-frontend-class)
  * [StoRM WebDAV class](#storm-webdav-class)
  * [StoRM GridFTP class](#storm-gridftp-class)
  * [StoRM database class](#storm-database-class)
  * [StoRM repo class](#storm-repo-class)
  * [StoRM users class](#storm-users-class)
* [Limitations - OS compatibility](#limitations)

## Description

StoRM Puppet module allows administrators to configure StoRM services deployed on CentOS 7.

The supported services are:

- StoRM Backend
- StoRM Frontend
- StoRM WebDAV
- StoRM Globus GridFTP

## Setup

StoRM Puppet module is available on puppet forge:

```shell
puppet module install cnafsd-storm
```

You can also build and install module from source code as follow:

```shell
git clone https://github.com/italiangrid/storm-puppet-module.git
cd storm-puppet-module
pdk build
puppet module install ./pkg/cnafsd-storm-*.tar.gz
```

## Usage

This Puppet module allows site administrators to properly configure StoRM services on CentOS 7 platform. This module provides some classes related to the main components and also 
some utility classes those can be used to configure StoRM repositories, StoRM users, VO pool accounts, LCMAPS and storage directories.

Component classes:

* [StoRM Backend class](#storm-backend-class)
* [StoRM Frontend class](#storm-frontend-class)
* [StoRM WebDAV class](#storm-webdav-class)
* [StoRM GridFTP class](#storm-gridftp-class)

Utility classes:

* [StoRM database class](#storm-database-class)
* [StoRM repo class](#storm-repo-class)
* [StoRM users class](#storm-users-class)

### StoRM Backend class

> **Prerequisites**: A MySQL or MariaDB server with StoRM databases must exist. Databases can be empty. If you want to use this module to install MySQL client and server and init databases, please read about [StoRM database utility class](#storm-database-class).

The Backend class installs:

- `storm-backend-mp` and all its related packages, such as `storm-backend-server`,
- `storm-native-libs-gpfs` in case GPFS is specified as filesystem,
- `storm-dynamic-info-provider`.

The Backend class configures `storm-backend-server` service by managing the following files:

- `/etc/storm/backend-server/storm.properties`
- `/etc/storm/backend-server/namespace.xml`
- `/etc/systemd/system/storm-backend-server.service.d/storm-backend-server.conf`
- `/etc/systemd/system/storm-backend-server.service.d/filelimit.conf`

and deploys StoRM databases. In addiction, this class configures and run `storm-info-provider` by managing the following file:

- `/etc/storm/info-provider/storm-yaim-variables.conf`.

The whole list of StoRM Backend class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Abackend.html).

Example of StoRM Backend configuration:

```Puppet
class { 'storm::backend':
  db_password         => 'secret-password',
  transfer_protocols  => ['gsiftp', 'webdav'],
  security_token      => 'secret-token',
  du_service_enabled  => true,
  srm_pool_members    => [
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
  storage_areas       => [
    {
      'name'          => 'dteam-disk',
      'root_path'     => '/storage/disk',
      'access_points' => ['/disk'],
      'vos'           => ['dteam'],
      'online_size'   => 40,
    },
    {
      'name'          => 'dteam-tape',
      'root_path'     => '/storage/tape',
      'access_points' => ['/tape'],
      'vos'           => ['dteam'],
      'online_size'   => 40,
      'nearline_size' => 80,
      'fs_type'       => 'gpfs',
      'storage_class' => 'T1D0',
    },
  ],
}
```

Starting from Puppet module v2.0.0, the management of Storage Site Report has been improved.
Site administrators can add script and cron described in the [how-to](http://italiangrid.github.io/storm/documentation/how-to/how-to-publish-json-report/) using a defined type `storm::backend::storage_site_report`.
For example:

```Puppet
storm::backend::storage_site_report { 'storage-site-report':
  report_path => '/storage/info/report.json', # the internal storage area path
  minute      => '*/20', # set cron's minute
}
```

#### Conversion table from v3.3.0 to v4.0.0

Since v4.0.0 a huge naming refactory has been done on Backend's storm.properties file and, as a consequence, also Puppet StoRM Backend's class has followed a similar renaming. The following table shows which properties have been removed, renamed or introduced.

| **Property name**<br/>_v3.3.0_     | **Property name**</br>_v4.0.0_ |
|:-----------------------------------|:-------------------------------|
| -                                  | `storm_properties_file`        |
| `hostname`                         | _Removed_                      |
| `install_native_libs_gpfs`         | _Removed_. The GPFS native libraries are installed automatically when GPFS is used as `fs_type` in at least one storage area. |
| `db_username`                      | `db_username`                  |
| `db_password`                      | `db_password`                  |
| `db_hostname`                      | `db_hostname`                  |
| `db_port`                          | `db_port`                      |
| `db_properties`                    | `db_properties`                |
| -                                  | `db_pool_size`                 |
| -                                  | `db_pool_min_idle`             |
| -                                  | `db_pool_max_wait_millis`      |
| -                                  | `db_pool_test_on_borrow`       |
| -                                  | `db_pool_test_while_idle`      |
| `xroot_hostname`                   | `xroot_hostname`               |
| `xroot_port`                       | `xroot_port`                   |
| `gsiftp_pool_balance_strategy`     | `gsiftp_pool_balance_strategy` |
| `gsiftp_pool_members`              | `gsiftp_pool_members`          |
| `webdav_pool_members`              | `webdav_pool_members`          |
| `srm_pool_members`                 | `srm_pool_members`             |
| `transfer_protocols`               | `transfer_protocols`           |
| `fs_type`                          | `fs_type`                      |
| `storage_areas`                    | `storage_areas`                |
| `frontend_public_host`             | _Removed_. The SRM public hostname is the hostname of the first `srm_pool_members` element. |
| `frontend_port`                    | _Removed_. The SRM public port is the port of the first `srm_pool_members` element.|
| `directory_automatic_creation`     | _Renamed_ to `directory_enable_automatic_creation` |
| `directory_writeperm`              | _Renamed_ to `directories_enable_writeperm_on_creation` |
| `rest_services_port`               | _Renamed_ to `rest_server_port` |
| `rest_services_max_threads`        | _Renamed_ to `rest_server_max_threads` |
| `rest_services_max_queue_size`     | _Renamed_ to `rest_server_max_queue_size` |
| `xmlrpc_unsecure_server_port`      | _Renamed_ to `xmlrpc_server_port` |
| `xmlrpc_maxthread`                 | _Renamed_ to `xmlrpc_server_max_threads` |
| `xmlrpc_max_queue_size`            | _Renamed_ to `xmlrpc_server_max_queue_size` |
| `xmlrpc_security_enabled`          | _Renamed_ to `security_enabled` |
| `xmlrpc_security_token`            | _Renamed_ to `security_token` |
| `ptg_skip_acl_setup`               | _Renamed_ to `skip_ptg_acl_setup` |
| `sanity_check_enabled`             | _Renamed_ to `sanity_checks_enabled` |
| `service_du_enabled`               | _Renamed_ to `du_service_enabled` |
| `service_du_delay`                 | _Renamed_ to `du_service_initial_delay` |
| `service_du_interval`              | _Renamed_ to `du_service_tasks_interval` |
| `max_ls_entries`                   | _Renamed_ to `synch_ls_max_entries` |
| -                                  | `synch_ls_default_all_level_recursive` |
| -                                  | `synch_ls_default_num_levels` |
| -                                  | `synch_ls_default_offset` |
| `gc_ptp_transit_start_delay`       | _Renamed_ to `inprogress_requests_agent_delay` |
| `gc_ptp_transit_interval`          | _Renamed_ to `inprogress_requests_agent_interval` |
| `gc_expired_inprogress_time`       | _Renamed_ to `inprogress_requests_agent_ptp_expiration_time` |
| `gc_pinnedfiles_cleaning_delay`    | _Renamed_ to `expired_spaces_agent_delay` |
| `gc_pinnedfiles_cleaning_interval` | _Renamed_ to `expired_spaces_agent_interval` |
| `gc_purge_enabled`                 | _Renamed_ to `completed_requests_agent_enabled` |
| -                                  | `completed_requests_agent_delay` |
| `gc_purge_interval`                | _Renamed_ to `completed_requests_agent_interval` |
| `gc_purge_size`                    | _Renamed_ to `completed_requests_agent_purge_size` |
| `gc_expired_request_time`          | _Renamed_ to `completed_requests_agent_purge_age` |
| `asynch_db_reconnect_period`       | _Removed_ |
| `asynch_db_delay_period`           | _Removed_ |
| `db_connection_pool_enabled`       | _Removed_ |
| `db_connection_pool_max_active`    | _Removed_ |
| `db_connection_pool_max_wait`      | _Removed_ |
| `asynch_picking_initial_delay`     | _Renamed_ to `requests_picker_agent_delay` |
| `asynch_picking_time_interval`     | _Renamed_ to `requests_picker_agent_interval` |
| `asynch_picking_max_batch_size`    | _Renamed_ to `requests_picker_agent_max_fetched_size` |
| `requests_scheduler_core_size`     | _Renamed_ to `requests_scheduler_core_pool_size` |
| `requests_scheduler_max_size`      | _Renamed_ to `requests_scheduler_max_pool_size` |
| `requests_scheduler_queue_size`    | `requests_scheduler_queue_size` |
| `ptp_requests_scheduler_core_size` | _Renamed_ to `ptp_scheduler_core_pool_size` |
| `ptp_requests_scheduler_max_size`  | _Renamed_ to `ptp_scheduler_max_pool_size` |
| `ptp_requests_scheduler_queue_size`| _Renamed_ to `ptp_scheduler_queue_size` |
| `ptg_requests_scheduler_core_size` | _Renamed_ to `ptg_scheduler_core_pool_size` |
| `ptg_requests_scheduler_max_size`  | _Renamed_ to `ptg_scheduler_max_pool_size` |
| `ptg_requests_scheduler_queue_size`| _Renamed_ to `ptg_scheduler_queue_size` |
| `bol_requests_scheduler_core_size` | _Renamed_ to `bol_scheduler_core_pool_size` |
| `bol_requests_scheduler_max_size`  | _Renamed_ to `bol_scheduler_max_pool_size` |
| `bol_requests_scheduler_queue_size`| _Renamed_ to `bol_scheduler_queue_size` |
| `extraslashes_file`                | `extraslashes_file` |
| -                                  | `extraslashes_rfio` |
| `extraslashes_gsiftp`              | `extraslashes_gsiftp` |
| `extraslashes_root`                | `extraslashes_root` |
| `jmx`                              | _Removed_ |
| `jmx_options`                      | _Removed_ |
| `debug_port`                       | _Removed_ |
| `debug_suspend`                    | _Removed_ |
| `lcmaps_db_file`                   | `lcmaps_db_file` |
| `lcmaps_policy_name`               | `lcmaps_policy_name` |
| `lcmaps_log_file`                  | `lcmaps_log_file` |
| `lcmaps_debug_level`               | `lcmaps_debug_level` |
| `storm_limit_nofile`               | `storm_limit_nofile` |
| `manage_path_authz_db`             | _Removed_. The logic changed to "if `path_authz_db_file` is defined, use it". |
| `pinlifetime_default`              | `pinlifetime_default` |
| `pinlifetime_maximum`              | `pinlifetime_maximum` |
| -                                  | `files_default_size` |
| -                                  | `files_default_lifetime` |
| -                                  | `files_default_overwrite` |
| -                                  | `files_default_storagetype` |
| `info_config_file`                 | `info_config_file` |
| `info_sitename`                    | `info_sitename` |
| `info_storage_default_root`        | `info_storage_default_root` |
| `info_endpoint_quality_level`      | `info_endpoint_quality_level` |
| `info_webdav_pool_list`            | _Removed_. A `published` option has been added to `webdav_pool_members` which is used to configure info provider. |
| `info_frontend_host_list`          | _Removed_. Used `srm_pool_members` to initialize the info provider |
| -                                  | `hearthbeat_bookkeeping_enabled` |
| -                                  | `hearthbeat_performance_measuring_enabled` |
| -                                  | `hearthbeat_period` |
| -                                  | `hearthbeat_performance_logbook_time_interval` |
| -                                  | `hearthbeat_performance_glance_time_interval` |
| -                                  | `info_quota_refresh_period` |
| -                                  | `abort_maxloop` |
| -                                  | `ping_properties_filename` |
| -                                  | `server_pool_status_check_timeout` |
| `http_turl_prefix`                 | `http_turl_prefix` |

#### Enable HTTP as transfer protocol for SRM

To enable HTTP as transfer protocol for SRM prepare-to-get and prepare-to-put requests, you must add `webdav` protocol to the list of your *transfer_protocols* and define at least one member for *webdav_pool_members*. You can re-define the default list of transfer protocols by adding your *storm::backend::transfer_protocols* variable and/or you can override this list by adding a specific *transfer_protocols* for each storage area:

```puppet
class { 'storm::backend':
  # ...
  'webdav_pool_members' => [
    {
      'hostname' => 'webdav.test.example',
    },
  ],
  # defines the default list of transfer protocols for each storage area:
  'transfer_protocols'  => ['gsiftp', 'webdav'], 
  'storage_areas'       => [
    {
      'name'          => 'sa-http-enabled',
      'root_path'     => '/storage/sa-http-enabled',
      'access_points' => ['/sa-http-enabled'],
      'vos'           => ['test.vo'],
      'online_size'   => 40,
    },
    {
      'name'               => 'sa-no-http-enabled',
      'root_path'          => '/storage/sa-no-http-enabled',
      'access_points'      => ['/sa-no-http-enabled'],
      'vos'                => ['test.vo'],
      'online_size'        => 40,
      # disable webdav protocol for this storage area
      'transfer_protocols' => ['file', 'gsiftp'],
    },
    # ...
  ],
  # ...
}
```

The *manifest.pp* showed above includes the HTTP transfer protocol for all the storage area defined.
By default, *storm::backend::transfer_protocols* includes only `file` and `gsiftp`.


### StoRM Frontend class

The StoRM Frontend class installs `storm-frontend-mp` and all the releated packages and configures `storm-frontend-server` service by managing the following files:

- `/etc/storm/frontend-server/storm-frontend-server.conf`
- `/etc/sysconfig/storm-frontend-server`

The whole list of StoRM Frontend class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Afrontend.html).

Example of StoRM Frontend configuration:

```Puppet
class { 'storm::frontend':
  be_xmlrpc_host  => 'backend.test.example',
  be_xmlrpc_token => 'NS4kYAZuR65XJCq',
  db_host         => 'backend.test.example',
  db_user         => 'storm',
  db_passwd       => 'secret-password',
}
```

### StoRM WebDAV class

The StoRM WebDAV class installs `storm-webdav` rpm and configures `storm-webdav` service by managing the following files:

- the systemd override files `filelimit.conf` and `storm-webdav.conf` stored into `/etc/systemd/system/storm-webdav.service.d`;
- the storage areas property files stored into `/etc/storm/webdav/sa.d` (optional);

The whole list of StoRM Webdav class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Awebdav.html).

Example of StoRM WebDAV configuration:

```Puppet
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
      access_points              => ['/test.vo.2', '/alias'],
      vos                        => ['test.vo.2'],
      authenticated_read_enabled => true,
    },
  ],
  hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
}
```

Storage Areas can also be configured singularly by using the defined type `storm::webdav::storage_area_file`. This strategy allows site administrators to keep their manifests unaware of the improvements on StoRM WebDAV code. For example, if a new property is added into Storage Area configuration files, you haven't to update your Puppet module and all the service configuration will continue working.

Example of Storage Areas configuration done with `storm::webdav::storage_area_file`:

```Puppet
class { 'storm::webdav':
  hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
}

storm::webdav::storage_area_file { 'test.vo.properties':
  source => '/path/to/my/test.vo.properties',
}

storm::webdav::storage_area_file { 'test.vo.2.properties':
  source => '/path/to/my/test.vo.2.properties',
}
```

Starting from Puppet module v2.0.0, the management of application.yml file has been removed from storm::webdav class.
Site administrators can edit their own configuration files or use a defined type `storm::webdav::application_file` to inject also one or more YAML files into the proper directory.
For example:

```Puppet
class { 'storm::webdav':
  hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
}

storm::webdav::application_file { 'application.yml':
  source => '/path/to/my/application.yml',
}

storm::webdav::application_file { 'application-wlcg.yml':
  source => '/path/to/my/application-wlcg.yml',
}
```


### StoRM GridFTP class

The StoRM GridFTP class installs `storm-globus-gridftp-mp` and configures `storm-globus-gridftp` service by managing the following files:

- `/etc/grid-security/gridftp.conf`, the main configuration file;
- `/etc/sysconfig/storm-globus-gridftp`, with the environment variables.

The whole list of StoRM GridFTP class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Agridftp.html).

Examples of StoRM Gridftp configuration:

```Puppet
class { 'storm::gridftp':
  redirect_lcmaps_log => true,
  llgt_log_file       => '/var/log/storm/storm-gridftp-lcmaps.log',
}
```

### StoRM database class

The StoRM database utility class installs `mariadb` server and releated rpms and configures `mysql` service by managing the following files:

- `/etc/my.cnf.d/server.cnf`;
- `/etc/systemd/system/mariadb.service.d/limits.conf`.

The whole list of StoRM Database class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Adb.html).

Examples of StoRM Database usage:

```Puppet
class { 'storm::db':
  root_password => 'supersupersecretword',
  storm_password => 'supersecretword',
}
```

### StoRM repo class

The StoRM repo utility class creates all the StoRM YUM repositories: stable, beta, nightly.
By default, only stable repo is enabled. You can also add extra repositories to install.

The whole list of StoRM repo class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Arepo.html).

Examples of StoRM Repo usage:

```Puppet
class { 'storm::repo':
  enabled => ['stable', 'beta'],
}
```

### StoRM users class

The StoRM users utility class creates the default StoRM users and groups.

Use:

```Puppet
include storm::users
```

to create default scenario:

- `storm` group with id 1100
- `edguser` group with id 1101
- `storm` user with id 1100, member of `storm` and `edguser` groups
- `edguser` user with id 1101, member of `edguser` and `storm` groups

You can also customize and create your own users and groups as follow:

```Puppet
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


The whole list of StoRM repo class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Ausers.html).

## Documentation

You can find all the info about module classes and parameters at:

- [StoRM Puppet module main site doc](https://italiangrid.github.io/storm-puppet-module)
- [REFERENCE.md](https://github.com/italiangrid/storm-puppet-module/blob/master/REFERENCE.md)


## Developers

Run tests with:

```
pdk test unit
```

Validate code with:

```
pdk validate
```

## Limitations

It works only on RedHat CentOS 7 distribution.
