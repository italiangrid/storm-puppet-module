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

- `storm-backend-mp` and all the releated packages;
- `storm-dynamic-info-provider`.

Then, the Backend class configures `storm-backend-server` service by managing the following files:

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
  hostname              => backend.test.example,
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
      'hostname' => webdav.test.example,
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

Starting from Puppet module v2.0.0, the management of Storage Site Report has been improved.
Site administrators can add script and cron described in the [how-to](http://italiangrid.github.io/storm/documentation/how-to/how-to-publish-json-report/) using a defined type `storm::backend::storage_site_report`.
For example:

```Puppet
storm::backend::storage_site_report { 'storage-site-report':
  report_path => '/storage/info/report.json', # the internal storage area path
  minute      => '*/20', # set cron's minute
}
```

#### Enable GPFS native libs on StoRM Backend

If you're running StoRM Backend on GPFS file system and you need to install the GPFS native libs, enable the installation through the Puppet module as follows:

```puppet
class { 'storm::backend':
  # ...
  'install_native_libs_gpfs' => true,
  # ...
}
```

In this case the *storm-native-libs-gpfs* library is added to the installed packages.

#### Enable HTTP as transfer protocol for SRM

To enable HTTP as transfer protocol for SRM prepare-to-get and prepare-to-put requests, you must add `webdav` protocol to the list of your *transfer_protocols* and define at least one member for *webdav_pool_members*. You can re-define the default list of transfer protocols by adding your *storm::backend::transfer_protocols* variable and/or you can override this list by adding a specific *transfer_protocols* for each storage area:

```puppet
class { 'storm::backend':
  # ...
  'webdav_pool_members' => [
    {
      'hostname' => webdav.test.example,
    },
  ],
  # defines the default list of transfer protocols for each storage area:
  'transfer_protocols'  => ['file', 'gsiftp', 'webdav'], 
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
  db_passwd       => 'storm',
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
