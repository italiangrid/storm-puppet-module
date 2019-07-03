# Class: storm
# ===========================
#
# StoRM puppet module
#
# Parameters
# ----------
#
# * `user_name`
# Unix user used to run StoRM services
# * `storm_storage_root_directory`
# Storage areas root directory path
# * `storage_areas`
# List of storage area's configuration.
#
# TO-DO add complete list of params
#
# Examples
# --------
#
# @example
#    class { 'storm':
#      user_name => 'storm',
#      storage_root_directory => '/storage',
#    }
#
# Authors
# -------
#
# Enrico Vianello <enrico.vianello@cnaf.infn.it>
#
# Copyright
# ---------
#
# Copyright (c) Istituto Nazionale di Fisica Nucleare (INFN). 2006-2010.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
#
class storm (

  #####
  # StoRM common configuration parameters
  #####

  # StoRM services run with this local Unix user. Default: 'storm'
  String $user_name = $storm::params::user_name,

  # The storage areas' root directory. Default: '/storage'
  String $storage_root_dir = $storm::params::storage_root_dir,

  # The list of defined storage areas. Default: []
  Array[Storm::StorageArea] $storage_areas = $storm::params::storage_areas,

  # StoRM configuration directory. Default: '/etc/storm'
  String $config_dir = $storm::params::config_dir,

  # StoRM log files directory. Default: '/var/log/storm'
  String $log_dir = $storm::params::log_dir,

  # List of components to configure on node. Default: []
  Array[Enum['webdav','backend','frontend','gridftp']] $components = $storm::params::components,

  #####
  # WebDAV component configuration parameters
  #####

  # StoRM WebDAV configuration directory. Default: '/etc/storm/webdav'
  String $webdav_config_dir = $storm::params::webdav_config_dir,

  String $webdav_hostcert_dir = $storm::params::webdav_hostcert_dir,

  Array[Struct[{
    name   => String,
    issuer => String,
  }]] $webdav_oauth_issuers = $storm::params::webdav_oauth_issuers,

  Array[String] $webdav_hostnames = $storm::params::webdav_hostnames,

  Integer $webdav_http_port = $storm::params::webdav_http_port,
  Integer $webdav_https_port = $storm::params::webdav_https_port,

  String $webdav_trust_anchors_dir = $storm::params::webdav_trust_anchors_dir,
  Integer $webdav_trust_anchors_refresh_interval = $storm::params::webdav_trust_anchors_refresh_interval,

  Integer $webdav_max_concurrent_connections = $storm::params::webdav_max_concurrent_connections,
  Integer $webdav_max_queue_size = $storm::params::webdav_max_queue_size,
  Integer $webdav_connector_max_idle_time = $storm::params::webdav_connector_max_idle_time,

  Boolean $webdav_vo_map_files_enable = $storm::params::webdav_vo_map_files_enable,
  String $webdav_vo_map_files_config_dir = $storm::params::webdav_vo_map_files_config_dir,
  Integer $webdav_vo_map_files_refresh_interval = $storm::params::webdav_vo_map_files_refresh_interval,

  String $webdav_log = $storm::params::webdav_log,
  String $webdav_log_configuration = $storm::params::webdav_log_configuration,
  String $webdav_access_log_configuration = $storm::params::webdav_access_log_configuration,

  Integer $webdav_tpc_max_connections = $storm::params::webdav_tpc_max_connections,
  Boolean $webdav_tpc_verify_checksum = $storm::params::webdav_tpc_verify_checksum,

) inherits storm::params {

  contain storm::install
  contain storm::config

  Class['::storm::install']
  -> Class['::storm::config']

  if 'webdav' in $components {
    class { 'storm::webdav': }
  }
}
