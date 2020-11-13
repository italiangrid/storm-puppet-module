# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0]

- Converted to pdk project
- Removed storm::storage class
- Added storm::sarootdir defined type
- Use hiera YAML files for all default parameters
- Removed all params.pp files

## [2.2.1] - 2020-11-09

- Fixed type into data file

## [2.2.0] - 2020-11-09

- Moved default parameters into YAML data files
- Deleted params.pp files
- Added hiera.yaml

## [2.1.0] - 2020-10-29

- Moved gridftp.conf into /etc/grid-security directory

## [2.0.1] - 2020-10-19

- Fixed CHANGELOG
- Improved documentation.

## [2.0.0] - 2020-10-19

- Added defined types for application-*.yml and storage area files used by WebDAV class.
- Removed direct support for application.yml template file.
- Added defined types for service conf files of Backend.
- Added defined type for storage site reporting.
- Added tests.
- Removed docker deploy image.

## [1.1.1] - 2020-10-06

- Removed log directory management

## [1.1.0] - 2020-10-05

- Removed storm::mapping class

## [1.0.5] - 2020-10-02

- Added path-authz.db support to StoRM Backend

## [1.0.0] - 2020-09-25

- Moved database creation and MySQL/MariaDB installation on a separated class storm::db
- Backend class only import SQL script of databases, only if database or table version not exists
- WebDAV class by default doesn't manage application.yml file. It can be optionally managed from a source or from variables.
- WebDAV class by default manage storage areas. A source directory or the array of storage areas can be provided.
- Mapping class also manages VOMS roles and multiple groups.
- Removed epel and umd repo from repo class
- Removed testca and testvos classes

## [0.2.3] - 2020-05-25

### Changed

- Allow enable/disable StoRM DSI module for gridftp

## [0.2.1] - 2020-05-25

### Changed

- Updated README.md

## [0.2.0] - 2020-05-15

### Added

- Support for StoRM Frontend service configuration

### Changed

- Fixed ignored WebDAV HTTP2 and Conscrypt options
- Allow redirection of LCMAPS logging to a particular file
- Fixed conflict on storm user/group creation when the same node install WebDAV and Frontend services

## [0.1.0] - 2019-10-09

### Added
- Support for StoRM WebDAV service configuration
- Support for StoRM GridFTP server configuration
- Documentation at REFERENCE.md
- Documentation at https://italiangrid.github.io/storm-puppet-module
