# Changelog

All notable changes to this project will be documented in this file.

## [4.3.1]

- Add notify on storage area source directory (StoRM WebDAV)

## [4.3.0]

- Add SciTags collector parameter `storm::webdav::scitags_collector`
- Update SciTags flow registry URL

## [4.2.0]
- Added the opportunity to specify an external source for WebDAV storage area directory. Use `storm::webdav::storage_areas_source_directory`. This parameter, if set, overrides `storm::webdav::storage_areas`.
- Enable SciTags support with `storm::webdav::scitags_enabled`.

## [4.1.0]
- Added the opportunity to specify an external source for Backend's storm.properties file. Use `storm::backend::manage_storm_properties` and `storm::backend::path_storm_properties`.

## [4.0.1]

- Added new StoRM WebDAV parameters for the related environment variables:
  - `storm::webdav::tls_protocol`
  - `storm::webdav::checksum_filter_enabled` 
  - `storm::webdav::macaroon_filter_enabled`
  - `storm::webdav::file_buffer_size`
  - `storm::webdav::voms_trust_store_dir`
  - `storm::webdav::voms_trust_store_refresh_interval_sec`
  - `storm::webdav::voms_cache_enabled`
  - `storm::webdav::voms_cache_entry_lifetime_sec`

## [4.0.0]

- Puppet version >= 7.0.0 is required
- Added `storm::gridftp::data_interface` parameter in order to support a configuration behind a public IP
- Added `storm::gridftp::log_level` parameter in order to allow logging level
- Removed `storm::webdav::ensure_empty_storage_area_dir`: storage area directory is now automatically purged of not managed properties files
- Added `storm::webdav::tpc_enable_expect_continue_threshold` in order to set a threshold from which an header with `Expect: 100 continue` is added
- Added `storm::webdav::user` parameter in order to allow the setting of a custom user used to run the service
- Added `storm::webdav::tape_wellknown_source` parameter in order to specify which JSON file has to be loaded as content of the well-known endpoint for WLCG Tape REST API implementation
- Within `update-site-report` script, JSON file is now moved and not copied to avoid the growth of useless files in `tmp` directory
- Removed `storm::backend::debug*` parameters
- Removed `storm::backend::install_native_libs_gpfs` parameter because the installation of the GPFS libs is done if at least one storage area has `fs_type` GPFS.
- Added a retry mechanism if StoRM Info Provider configure command fails
- Removed the custom management of systemctl daemon reload because now it's supported by Puppet 7

## [3.4.0]

- Removed useless storm::frontend parameters gridmap_dir and gridmap_file 

## [3.3.2]

- Changed default value to an empty array for vos field of Storm::Webdav::StorageArea
- Added pool of webdav endpoints into backend's namespace.xml

## [3.3.1]

- Added missing Argus's resource-id parameter within Frontend's configuration.
- Added support for using an external file for StoRM Frontend's configuration file.
- Removed storm::frontend::security_enable_mapping parameter.
- The `storm::frontend::be_xmlrpc_host` value is initialized with local FQDN.

## [3.3.0]

- Added missing StoRM WebDAV configuration parameters
- StoRM WebDAV hostname list initialized with local FQDN
- Added storm::webdav::drop_in_file define in order to allow adding custom drop-in files to be stored in /etc/systemd/system/storm-webdav.service.d 
- Added `storm::webdav::tpc_max_connections_per_route`, `storm::webdav::tpc_timeout_in_secs`, `storm::webdav::tpc_tls_protocol`, `storm::webdav::tpc_report_delay_secs`, `storm::webdav::tpc_enable_tls_client_auth`, `storm::webdav::tpc_progress_report_thread_pool_size` parameters.
- Removed `storm::webdav::manage_storage_areas` parameter. The logic has been simplified to managing storage areas only if `storm::webdav::storage_areas` list is defined.
- Added `storm::webdav::ensure_empty_storage_area_dir` parameter to ensure a cleaned storage area directory before adding the .properties files.
- Increased StoRM WebDAV default heap size to 1024m and default timeout for TPC to 30 seconds

## [3.2.1]

- Fixed permissions on info-provider configuration file

## [3.2.0]

- Added daemon reload on backend and webdav restart command

## [3.1.1]

- Improved README. No changes on module.

## [3.1.0]

- Added mode parameter to storm::rootdir and storm::sarootdir defined types
- Increased default value for wait_timeout in storm::db::override_options

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
