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

- installs:
    - `storm-backend-mp` and all the releated packages;
    - `storm-dynamic-info-provider`;
    - MySQL community client;
    - MySQL community server (if enabled);
- creates and initializes StoRM database;
- configures `storm-backend-server` service;
- configures `storm-info-provider`.

The main StoRM Backend configuration parameters are:

- `hostname`: StoRM Backend Fully Qualified Domain Name. **Required**.
- `db_username` and `db_password`: database credentials. Default values are username **storm** and password **storm**.
- `install_native_libs_gpfs`: Set this if you need to install storm-native-libs-gpfs. Default value: **false**.
- `mysql_server_install`: Set this if you need to install and configure a MySQL server. Default value: **false**.
- `mysql_server_root_password`: Set this if you have set `mysql_server_install` to true. Default value: **storm**.
- `synchcall_xmlrpc_security_token`: The token that the backend will require to be present for accepting XML-RPC requests. It must be equal to the one defined for StoRM Frontend. Default value: **secret**.
- `srm_pool_members`: the list of `Storm::Backend::SrmPoolMember` elements (more info below). Required even if Frontend and Backend are on the same host.
- `frontend_public_host`: StoRM Frontend hostname in case of a single Frontend StoRM deployment, StoRM Frontends DNS alias in case of a multiple Frontends StoRM deployment. Default value is the value of `hostname` parameter.
- `gsiftp_pool_members`: the list of `Storm::Backend::GsiftpPoolMember` elements (more info below). Required even if GridFTP and Backend are on the same host.
- `webdav_pool_members`: the list of `Storm::Backend::WebdavPoolMember` elements (more info below). Required even if WebDAV and Backend are on the same host.
- `storage_areas`: the list of `Storm::Backend::StorageArea` elements (more info below).

The Info Provider related parameters are:

- `info_sitename`: A string that stands for the name of the site. Default: **StoRM site**.
- `info_storage_default_root`: The default storage area root directory. Default: **/storage**.
- `info_endpoint_quality_level`: Endpoint maturity level to be published by the Info Provider. Optional variable. Default value: **2**.

Other StoRM Backend configuration parameters:

- `mysql_server_override_options`: Configure MySQL Server with your personal needs by overriding options. Read more on the related [MySQL Puppet module documentation](https://forge.puppet.com/puppetlabs/mysql#override_options).
- `xroot_hostname`: Root server (default value for all Storage Areas). Note: you may change the settings for each SA acting on its configuration. Default value is the value of `hostname` parameter.
- `xroot_port`: Root server port (default value for all Storage Areas). Default value: **1094**.
- `gsiftp_pool_balance_strategy`: Load balancing strategy for GridFTP server pool (default value for all Storage Areas). Note: you may change the settings for each SA acting on its configuration. Available values: round-robin, smart-rr, random, weight. Default value: round-robin.
- `transfer_protocols`: List of supported (and published) transfer protocols (default value for all Storage Areas). Note: you may change the settings for each SA acting on its configuration. Default value: **['file', 'gsiftp']**.
- `fs_type`: File System Type (default value for all Storage Areas). Note: you may change the settings for each SA acting on its configuration. Available values: posixfs, gpfs and test. Default value: **posixfs**.
- `frontend_port`: StoRM Frontend service port. Optional variable. Default value: **8444**.
- `synchcall_xmlrpc_unsecure_server_port`: Port to listen on for incoming XML-RPC connections from Frontends(s). Default: **8080**.
- `synchcall_xmlrpc_maxthread`: Number of threads managing XML-RPC connection from Frontends(s). A well sized value for this parameter have to be at least equal to the sum of the number of working threads in all Frontend(s). Default: **256**.
- `synchcall_xmlrpc_max_queue_size`: Number of queued threads managing XML-RPC connection from Frontends(s). Default: **1000**.
- `synchcall_xmlrpc_security_enabled`: Whether the backend will require a token to be present for accepting XML-RPC requests. Default: **true**.
- `ptg_skip_acl_setup`: Skip ACL setup for prepareToGet requests. Default: **false**.
- `sanity_check_enabled`: Enable|Disable sanity checks on bootstrap phase. Default: **true**.
- `synchcall_max_ls_entries`: Maximum number of entries returned by an srmLs call. Since in case of recursive srmLs results can be in order of million, this prevent a server overload. Default: **2000**.
- `rest_services_port`: StoRM backend server rest port. Optional variable. Default value: **9998**.
- `rest_services_max_threads`: Number of threads managing REST connections. Default: **100**.
- `rest_services_max_queue_size`: Number of queued threads managing REST connections. Default: **1000**.
- `service_du_enabled`:  Flag to enable disk usage service. Default: **false**.
- `service_du_delay`: The initial delay before the service is started (seconds). Default: **60**.
- `service_du_interval` The interval in seconds between successive run. Default: **360**.
- `gc_pinnedfiles_cleaning_delay`: Initial delay before starting the reserved space, JIT ACLs and pinned files garbage collection process, in seconds. Default: **10**.
- `gc_pinnedfiles_cleaning_interval`: Time interval in seconds between successive purging run. Default: **300**.
- `gc_purge_enabled`: Enable the request garbage collector. Default: **true**.
- `gc_purge_interval`: Time interval in seconds between successive purging run. Default: **600**.
- `gc_purge_size`: Number of requests picked up for cleaning from the requests garbage collector at each run. This value is use also by Tape Recall Garbage Collector. Default: **800**.
- `gc_expired_request_time`: Time in seconds to consider a request expired after its submission. Default: **604800** seconds (1 week). From StoRM 1.11.13 it is used also to identify how much time is needed to consider a completed recall task as cleanable.
- `gc_expired_inprogress_time`: Time in seconds to consider an in-progress ptp request as expired. Default: **2592000** seconds (1 month).
- `gc_ptp_transit_interval`: Time interval in seconds between successive expired put requests agent run. Default: **3000**.
- `gc_ptp_transit_start_delay`: Initial delay before starting the expired put requests agent process, in seconds. Default: **60**.
- `extraslashes_file`: Add extra slashes after the “authority” part of a TURL for file protocol. Defaul: ''.
- `extraslashes_root`: Add extra slashes after the “authority” part of a TURL for xroot protocol. Default: **/**.
- `extraslashes_gsiftp`: Add extra slashes after the “authority” part of a TURL for gsiftp protocol. Default: **/**.
- `db_connection_pool_enabled`: Enable the database connection pool. Default: **true**.
- `db_connection_pool_max_active`: Database connection pool max active connections. Default: **10**.
- `db_connection_pool_max_wait`: Database connection pool max wait time to provide a connection. Default: **50**
- `pinlifetime_default`: Default PinLifetime in seconds used for pinning files in case of srmPrepareToPut or srmPrepareToGet operation without any pinLifetime specified. Default: **259200**.
- `pinlifetime_maximum`: Maximum PinLifetime allowed in seconds. Default: **1814400**.
- `directory_automatic_creation`: Flag to enable automatic missing directory creation upon srmPrepareToPut requests. Default: **false**.
- `directory_writeperm`: Flag to enable directory write permission setting upon srmMkDir requests on created directories. Default: **false**.
- `asynch_db_reconnect_period`: Database connection refresh time intervall in seconds. Default: **18000**.
- `asynch_db_delay_period`: Database connection refresh initial delay in seconds. Default: **30**.
- `asynch_picking_initial_delay`: Initial delay before starting to pick requests from the DB, in seconds. Default: **1**.
- `asynch_picking_time_interval`: Polling interval in seconds to pick up new SRM requests. Default: **2**.
- `asynch_picking_max_batch_size`: Maximum number of requests picked up at each polling time. Default: **100**.
- `requests_scheduler_core_size`: Crusher Scheduler worker pool base size. Default: **50**.
- `requests_scheduler_max_size`: Crusher Schedule worker pool max size. Default: **200**.
- `requests_scheduler_queue_size`: Request queue maximum size. Default: **2000**.
- `ptp_requests_scheduler_core_size`: PrepareToPut worker pool base size. Default: **50**.
- `ptp_requests_scheduler_max_size`: PrepareToPut worker pool max size. Default: **200**.
- `ptp_requests_scheduler_queue_size`: PrepareToPut request queue maximum size. Default: **1000**.
- `ptg_requests_scheduler_core_size`: PrepareToGet worker pool base size. Default: **50**.
- `ptg_requests_scheduler_max_size`: PrepareToGet worker pool max size. Default: **200**.
- `ptg_requests_scheduler_queue_size`: PrepareToGet request queue maximum size. Default: **2000**.
- `bol_requests_scheduler_core_size`: BringOnline worker pool base size. Default: **50**.
- `bol_requests_scheduler_max_size`: BringOnline Worker pool max size. Default: **200**.
- `bol_requests_scheduler_queue_size`: BringOnline request queue maximum size. Default: **2000**.
- `jvm_options`: JVM options. Default: **-Xms512m -Xmx512m**.
- `jmx`: Flag to enable JMX options. Default: **false**.
- `jmx_options`: Default: **-Dcom.sun.management.jmxremote.port=8501 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false**.
- `lcmaps_db_file`: LCMPAS configuration file. Default: **/etc/storm/backend-server/lcmaps.db**.
- `lcmaps_policy_name`: LCMAPS policy name. Default: **standard**.
- `lcmaps_log_file`: LCMAPS logging file. Default: **/var/log/storm/lcmaps.log**.
- `lcmaps_debug_level`: LCMAPS debug level. Default: **0**.


Example of StoRM Backend configuration:

```

class { 'storm::backend':
  hostname              => backend.test.example,
  mysql_server_install  => true,
  frontend_public_host  => frontend.test.example,
  transfer_protocols    => ['file', 'gsiftp', 'webdav'],
  xmlrpc_security_token => 'NS4kYAZuR65XJCq',
  service_du_enabled    => true,
  srm_pool_members      => [
    {
      'hostname' => frontend.test.example,
    }
  ],
  gsiftp_pool_members   => [
    {
      'hostname' => gridftp.test.example,
    },
  ],
  webdav_pool_members   => [
    {
      'hostname' => wendav.test.example,
    },
  ],
  storage_areas         => [
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

### StoRM Frontend component

The main StoRM Frontend configuration parameters are:

- `be_xmlrpc_host`: StoRM Backend Fully Qualified Domain Name. **Required**.
- `be_xmlrpc_token`: Token used for communicating with Backend service. Default: **secret**.
- `db_host`: Host for database connection. Default is set to `be_xmlrpc_host` value.
- `db_user`: User for database connection. Default is **storm**.
- `db_passwd`: Password for database connection. Default is **storm**.

Other StoRM Frontend configuration parameters:

- `port`: Frontend service port. Default is **8444**.
- `be_xmlrpc_port`: Backend XML-RPC server port. Default is **8080**.
- `be_xmlrpc_path`: XML-RPC server path. Default is **/RPC2**.
- `be_recalltable_port`: REST server port running on the Backend machine. Default is **9998**.
- `threadpool_maxpending`: Size of the internal queue used to maintain SRM tasks in case there are no free worker threads. Default is **200**.
- `threadpool_threads_number`: Size of the worker thread pool. Default is **50**.
- `gsoap_maxpending`: Size of the GSOAP queue used to maintain pending SRM requests. Default is **1000**.
- `check_user_blacklisting`: Enable/disable user blacklisting. Default is **false**.
- `argus_pepd_endpoint`:  The complete service endpoint of Argus PEP server. Mandatory if `check_user_blacklisting` is true.
- `monitoring_enabled`: Enable/disable monitoring. Default is **true**.
- `monitoring_time_interval`: Time interval in seconds between each monitoring round. Default is **60**.
- `monitoring_detailed`: Enable/disable detailed monitoring. Default is **false**.
- `security_enable_mapping`: Flag to enable/disable DN-to-userid mapping via gridmap-file. Default is **false**.
- `security_enable_vomscheck`: Flag to enable/disable checking proxy VOMS credentials. Default is **true**.
- `log_debuglevel`: Logging level. Possible values are: ERROR, WARN, INFO, DEBUG, DEBUG2. Default is **INFO**.
- `gridmap_dir`: Gridmap directory path. Defailt value is: **/etc/grid-security/gridmapdir**.
- `gridmap_file`: Gridmap file path. Defailt value is: **/etc/grid-security/grid-mapfile**.

Example of StoRM Frontend configuration:

```
class { 'storm::frontend':
  be_xmlrpc_host  => 'backend.test.example',
  be_xmlrpc_token => 'NS4kYAZuR65XJCq',
  db_host         => 'backend.test.example',
  db_user         => 'storm',
  db_passwd       => 'storm',
}
```

Check [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Afrontend.html) for all Frontend class options.

### StoRM WebDAV component

The main StoRM WebDAV configuration parameters are:

- `storage_areas`: the list of `Storm::Webdav::StorageArea` elements (more info below).
- `oauth_issuers`: the list of `Storm::Webdav::OAuthIssuer` elements that means the supported OAuth providers (more info below).
- `hostnames`: the list of hostname and aliases supported for Third-Party-Copy.
- `http_port` and `https_port`: the service ports. Default: **8085**, **8443**.

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

The StoRM GridFTP configuration parameters are:

- `port`: the port used by GridFTP server service. Default: **2811**.
- `port_range`: the range of ports used by transfer sockets; format is 'MIN,MAX'. Default: **'20000,25000'**.
- `connections_max`: the number of max allowed connections to server. Default: **2000**.
- `redirect_lcmaps_log`: If true, redirect the LCMAPS log to the file specified by `llgt_log_file`. Default: **false**.
- `llgt_log_file`: The LCMAPS log file used if `redirect_lcmaps_log` is true. Default: **'/var/log/storm/storm-gridftp-lcmaps.log'**.

Other StoRM GridFTP configuration parameters:

- `log_single`: Session log file path. Default is: **/var/log/storm/storm-gridftp-session.log**.
- `log_transfer`: Transfer log file path. Default is: **/var/log/storm/storm-globus-gridftp.log**.
- `lcmaps_debug_level`: The LCMAPS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default: **3** (INFO).
- `lcas_debug_level`: The LCAS logging level. Values from 0 (ERROR) to 5 (DEBUG). Default: **3** (INFO).
- `load_storm_dsi_module`: Enable/Disable StoRM DSI module. Default: **true** (enabled).

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
