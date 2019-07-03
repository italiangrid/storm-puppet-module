# Class: storm::webdav::service
# ===========================
#
class storm::webdav::service {

  service { 'storm-webdav':
    ensure    => running,
    enable    => true,
    subscribe => File["${storm::webdav_config_dir}/config/application.yml"],
  }
}
