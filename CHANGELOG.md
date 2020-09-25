# Changelog

All notable changes to this project will be documented in this file.

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
