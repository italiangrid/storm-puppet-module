# StoRM puppet module

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
1. [Usage](#usage)
1. [Limitations - OS compatibility](#limitations)

## Description

StoRM Puppet module allows administrators to configure StoRM services deployed on CentOS 7.

The supported services are:

- StoRM Backend
- StoRM Frontend
- StoRM WebDAV
- StoRM Globus GridFTP

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
* [StoRM mapping class](#storm-mapping-class)
* [StoRM storage class](#storm-storage-class)

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

### StoRM Frontend class

The StoRM Frontend class installs `storm-frontend-mp` and all the releated packages and configures `storm-frontend-server` service by managing the following files:

- `/etc/storm/frontend-server/storm-frontend-server.conf`
- `/etc/sysconfig/storm-frontend-server`

The whole list of StoRM Frontend class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Afrontend.html).

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

### StoRM WebDAV class

The StoRM WebDAV class installs `storm-webdav` rpm and configures `storm-webdav` service by managing the following files:

- the systemd override files `filelimit.conf` and `storm-webdav.conf` stored into `/etc/systemd/system/storm-webdav.service.d`;
- the storage areas property files stored into `/etc/storm/webdav/sa.d` (optional);
- the `application.yml` file in `/etc/storm/webdav/comfig` (optional).

The whole list of StoRM Webdav class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Awebdav.html).

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
      access_points              => ['/test.vo.2', '/alias'],
      vos                        => ['test.vo.2'],
      authenticated_read_enabled => true,
    },
  ],
  oauth_issuers => [
    {
      name   => 'indigo-dc',
      issuer => 'https://iam-test.indigo-datacloud.eu/',
    },
  ],
  hostnames => ['storm-webdav.test.example', 'alias-for-storm-webdav.test.example'],
}
```

### StoRM GridFTP class

The StoRM GridFTP class installs `storm-globus-gridftp-mp` and configures `storm-globus-gridftp` service by managing the following files:

- `/etc/gridftp.conf`, the main configuration file;
- `/etc/sysconfig/storm-globus-gridftp`, with the environment variables.

The whole list of StoRM GridFTP class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Agridftp.html).

Examples of StoRM Gridftp configuration:

```
class { 'storm::gridftp':
  redirect_lcmaps_log => true,
  llgt_log_file       => '/var/log/storm/storm-gridftp-lcmaps.log',
}
```

### StoRM database class

The StoRM database utility class installs `mariadb` server and releated rpms and configures `mysql` service by managing the following files:

- `/etc/my.cnf.d/server.cnf`;
- `/etc/systemd/system/mysqld.service.d/override.conf`.

The whole list of StoRM Database class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Adb.html).

Examples of StoRM Database usage:

```
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

```
class { 'storm::repo':
  enabled => ['stable', 'beta'],
}
```

### StoRM users class

The StoRM users utility class creates the default StoRM users and groups.

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


The whole list of StoRM repo class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Ausers.html).

### StoRM storage class

To create the root directories of your storage areas, you can use the `storm::storage` utility class. This class is mainly used for test purposes. We expected not to use this class on production.

The whole list of StoRM storage class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Astorage.html).

Example of StoRM storage usage on our testbed:

```
file { '/storage':
  ensure  => directory,
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  recurse => false,
} -> class { 'storm::storage':
  root_directories => [
    '/storage/test.vo',
    '/storage/test.vo.2',
    '/storage/tape',
    '/storage/info',
  ],
}
```

### StoRM mapping class

The StoRM mapping utility class installs the following rpms:

- `lcmaps`
- `lcmaps-without-gsi`
- `lcmaps-plugins-basic`
- `lcmaps-plugins-voms`
- `lcas`
- `lcas-lcmaps-gt4-interface`
- `lcas-plugins-basic`
- `lcas-plugins-voms`

Then, it creates the following directories/files:

- `/etc/grid-security/gridmapdir`
- `/etc/grid-security/grid-mapfile`
- `/etc/grid-security/groupmapfile`
- `/etc/grid-security/gsi-authz.conf` (optional)
- `/etc/lcmaps/lcmaps.db` (optional)
- `/etc/lcas/lcas.db` (optional)
- `/etc/lcas/ban_users.db` (optional)

The content of grid-mapfile and groupmapfile and the content of gridmapdir directory depends on the pool accounts defined.

By default, the pool accounts needed by our testbed are created though the parameter `pools`:

```puppet

  $pools = [{
    'name' => 'tstvo',
    'size' => 20,
    'base_uid' => 7100,
    'group' => 'testvo',
    'groups' => ['testvo'],
    'gid' => 7100,
    'vo' => 'test.vo',
    'role' => 'NULL',
  },{
    'name' => 'testdue',
    'size' => 20,
    'base_uid' => 8100,
    'group' => 'testvodue',
    'groups' => ['testvodue'],
    'gid' => 8100,
    'vo' => 'test.vo.2',
    'role' => 'NULL',
  }],

```

The whole list of StoRM Mapping class parameters can be found [here](https://italiangrid.github.io/storm-puppet-module/puppet_classes/storm_3A_3Amapping.html).

Examples of StoRM Mapping usage:

```
include 'storm::mapping'
```

## Documentation

You can find all the info about module classes and parameters at:

- [StoRM Puppet module main site doc](https://italiangrid.github.io/storm-puppet-module)
- [REFERENCE.md](https://github.com/italiangrid/storm-puppet-module/blob/master/REFERENCE.md)

### How to update doc (for developers)

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
