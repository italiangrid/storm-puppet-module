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

## Setup

Build and install module as follow:

```
puppet module build
puppet module install ./pkg/cnafsd-storm-0.2.2.tar.gz
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
