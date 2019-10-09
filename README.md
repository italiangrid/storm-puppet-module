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

## Setup

Build and install module as follow:

```
puppet module build
puppet module install ./pkg/mwdevel-storm-0.1.0.tar.gz
```

## Usage

Check [this](https://github.com/italiangrid/storm-puppet-module/blob/master/examples/init.pp) example of `manifest.pp` or [Documentation](#documentation) section.

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
