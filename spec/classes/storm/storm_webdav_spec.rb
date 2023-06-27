require 'spec_helper'

describe 'storm::webdav', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'Define some test storage areas' do
        let(:params) do
          {
            'storage_areas' => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'vos' => ['test.vo', 'test.vo.2'],
                'authenticated_read_enabled' => true,
                'vo_map_enabled' => false,
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'access_points' => ['/atlas', '/atlasdisk'],
                'filesystem_type' => 'gpfs',
                'orgs' => ['atlas'],
                'anonymous_read_enabled' => true,
                'orgs_grant_read_permission' => false,
                'wlcg_scope_authz_enabled' => true,
                'fine_grained_authz_enabled' => true,
              },
            ],
            'hostnames' => ['storm-w1.example', 'storm-w2.example'],
            'http_port' => 8080,
            'https_port' => 9443,
            'max_concurrent_connections' => 200,
            'max_queue_size' => 700,
            'connector_max_idle_time' => 15_000,
            'vo_map_files_enable' => true,
            'vo_map_files_refresh_interval' => 22_000,
            'trust_anchors_refresh_interval' => 80_000,

            'tpc_max_connections' => 100,
            'tpc_max_connections_per_route' => 50,
            'tpc_verify_checksum' => true,
            'tpc_timeout_in_secs' => 10,
            'tpc_tls_protocol' => 'tlsVersion',
            'tpc_report_delay_secs' => 20,
            'tpc_enable_tls_client_auth' => true,
            'tpc_progress_report_thread_pool_size' => 250,

            'jvm_opts' => '-Xms512m -Xmx1024m',

            'authz_server_enable' => true,
            'authz_server_issuer' => 'https://storm-w1.example:9443',
            'authz_server_max_token_lifetime_sec' => 43_400,
            'authz_server_secret' => 'secret',
            'require_client_cert' => true,
            'storm_limit_nofile' => 1046,
            'tape_wellknown_source' => '/etc/storm/custom-file.json',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'config class is used' do
          is_expected.to contain_class('storm::webdav::config')
        end

        it 'check storm-webdav host certificate and key' do
          is_expected.to contain_file('/etc/grid-security/storm-webdav').with(
            ensure: 'directory',
            owner:  'storm',
            group:  'storm',
            mode:   '0755',
          )
          is_expected.to contain_file('/etc/grid-security/storm-webdav/hostcert.pem').with(
            ensure: 'file',
            owner:  'storm',
            group:  'storm',
            mode:   '0644',
          )
          is_expected.to contain_file('/etc/grid-security/storm-webdav/hostkey.pem').with(
            ensure: 'file',
            owner:  'storm',
            group:  'storm',
            mode:   '0400',
          )
        end

        it 'check java.io.tmpdir exists' do
          is_expected.to contain_file('/var/lib/storm-webdav/work').with(
            ensure: 'directory',
            owner:  'storm',
            group:  'storm',
            mode:   '0755',
          )
        end

        it 'check storage area is cleared of other properties files ' do
          is_expected.to contain_file('/etc/storm/webdav/sa.d').with(
            ensure: 'directory',
            recurse: true,
            purge: true,
          )
          is_expected.to contain_file('/etc/storm/webdav/sa.d/README.md').with(
            ensure: 'file',
          )
          is_expected.to contain_file('/etc/storm/webdav/sa.d/sa.properties.template').with(
            ensure: 'file',
          )
        end

        it 'check storage area properties files' do
          # test.vo properties
          testvo_props = '/etc/storm/webdav/sa.d/test.vo.properties'
          is_expected.to contain_file(testvo_props).with(
            ensure: 'file',
          )
          is_expected.to contain_file(testvo_props).with(content: %r{name=test.vo})
          is_expected.to contain_file(testvo_props).with(content: %r{rootPath=\/storage\/test.vo})
          is_expected.to contain_file(testvo_props).with(content: %r{filesystemType=posix})
          is_expected.to contain_file(testvo_props).with(content: %r{accessPoints=\/test.vo})
          is_expected.to contain_file(testvo_props).with(content: %r{vos=test.vo,test.vo.2})
          is_expected.to contain_file(testvo_props).with(content: %r{orgs=})
          is_expected.to contain_file(testvo_props).with(content: %r{authenticatedReadEnabled=true})
          is_expected.to contain_file(testvo_props).with(content: %r{anonymousReadEnabled=false})
          is_expected.to contain_file(testvo_props).with(content: %r{voMapEnabled=false})
          is_expected.to contain_file(testvo_props).with(content: %r{voMapGrantsWritePermission=false})
          is_expected.to contain_file(testvo_props).with(content: %r{orgsGrantReadPermission=true})
          is_expected.to contain_file(testvo_props).with(content: %r{orgsGrantWritePermission=false})
          is_expected.to contain_file(testvo_props).with(content: %r{wlcgScopeAuthzEnabled=false})
          is_expected.to contain_file(testvo_props).with(content: %r{fineGrainedAuthzEnabled=false})
          is_expected.to contain_file(testvo_props).that_notifies(['Service[storm-webdav]'])
          # atlas properties
          atlas_props = '/etc/storm/webdav/sa.d/atlas.properties'
          is_expected.to contain_file(atlas_props).with(
            ensure: 'file',
          )
          is_expected.to contain_file(atlas_props).with(content: %r{name=atlas})
          is_expected.to contain_file(atlas_props).with(content: %r{rootPath=\/storage\/atlas})
          is_expected.to contain_file(atlas_props).with(content: %r{filesystemType=gpfs})
          is_expected.to contain_file(atlas_props).with(content: %r{accessPoints=\/atlas,\/atlasdisk})
          is_expected.to contain_file(atlas_props).with(content: %r{vos=})
          is_expected.to contain_file(atlas_props).with(content: %r{orgs=atlas})
          is_expected.to contain_file(atlas_props).with(content: %r{authenticatedReadEnabled=false})
          is_expected.to contain_file(atlas_props).with(content: %r{anonymousReadEnabled=true})
          is_expected.to contain_file(atlas_props).with(content: %r{voMapEnabled=true})
          is_expected.to contain_file(atlas_props).with(content: %r{voMapGrantsWritePermission=false})
          is_expected.to contain_file(atlas_props).with(content: %r{orgsGrantReadPermission=false})
          is_expected.to contain_file(atlas_props).with(content: %r{orgsGrantWritePermission=false})
          is_expected.to contain_file(atlas_props).with(content: %r{wlcgScopeAuthzEnabled=true})
          is_expected.to contain_file(atlas_props).with(content: %r{fineGrainedAuthzEnabled=true})
          is_expected.to contain_file(atlas_props).that_notifies(['Service[storm-webdav]'])
        end

        it 'check environment file' do
          service_file = '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf'
          is_expected.to contain_file(service_file).with(
            ensure: 'file',
          )
          is_expected.to contain_file(service_file).that_notifies(['Service[storm-webdav]'])
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_USER=storm"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_HOSTNAME_0=storm-w1.example"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_HOSTNAME_1=storm-w2.example"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_HTTP_PORT=8080"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_HTTPS_PORT=9443"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_CERTIFICATE_PATH=\/etc\/grid-security\/storm-webdav\/hostcert.pem"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_PRIVATE_KEY_PATH=\/etc\/grid-security\/storm-webdav\/hostkey.pem"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_MAX_CONNECTIONS=200"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_MAX_QUEUE_SIZE=700"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_SA_CONFIG_DIR=\/etc\/storm\/webdav\/sa.d"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_VO_MAP_FILES_ENABLE=true"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_VO_MAP_FILES_CONFIG_DIR=\/etc\/storm\/webdav\/vo-mapfiles.d"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_VO_MAP_FILES_REFRESH_INTERVAL=22000"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_LOG=\/var\/log\/storm\/webdav\/storm-webdav-server.log"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_LOG_CONFIGURATION=\/etc\/storm\/webdav\/logback.xml"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_ACCESS_LOG_CONFIGURATION=\/etc\/storm\/webdav\/logback-access.xml"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_CONNECTOR_MAX_IDLE_TIME=15000"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TRUST_ANCHORS_DIR=\/etc\/grid-security\/certificates"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TRUST_ANCHORS_REFRESH_INTERVAL=80000"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_MAX_CONNECTIONS=100"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_MAX_CONNECTIONS_PER_ROUTE=50"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_VERIFY_CHECKSUM=true"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_TIMEOUT_IN_SECS=10"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_TLS_PROTOCOL=tlsVersion"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_REPORT_DELAY_SECS=20"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_ENABLE_TLS_CLIENT_AUTH=true"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_PROGRESS_REPORT_THREAD_POOL_SIZE=250"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_JVM_OPTS=-Xms512m -Xmx1024m"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_AUTHZ_SERVER_ENABLE=true"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_AUTHZ_SERVER_ISSUER=https:\/\/storm-w1.example:9443"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_AUTHZ_SERVER_MAX_TOKEN_LIFETIME_SEC=43400"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_AUTHZ_SERVER_SECRET=secret"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_REQUIRE_CLIENT_CERT=true"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_USE_CONSCRYPT=false"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TPC_USE_CONSCRYPT=false"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_ENABLE_HTTP2=false"})
          is_expected.to contain_file(service_file).with(content: %r{Environment="STORM_WEBDAV_TAPE_WELLKNOWN_SOURCE=\/etc\/storm\/custom-file.json"})
        end

        it 'check storm-webdav.service.d/filelimit.conf exists' do
          limit_file = '/etc/systemd/system/storm-webdav.service.d/filelimit.conf'
          is_expected.to contain_file(limit_file).with(
            ensure: 'file',
            owner:  'root',
            group:  'root',
            mode:   '0644',
            content: %r{^LimitNOFILE=1046},
          )
        end
      end

      context 'Test conscrypt enabled configuration' do
        let(:params) do
          {
            'use_conscrypt' => true,
            'tpc_use_conscrypt' => true,
          }
        end

        it 'check sysconfig conscrypt configuration is enabled' do
          service_file = '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf'
          is_expected.to contain_file(service_file).with(
            content: %r{^Environment="STORM_WEBDAV_USE_CONSCRYPT=true"},
          )
          is_expected.to contain_file(service_file).with(
            content: %r{^Environment="STORM_WEBDAV_TPC_USE_CONSCRYPT=true"},
          )
        end
      end

      context 'Test HTTP2 enabled configuration' do
        let(:params) do
          {
            'enable_http2' => true,
          }
        end

        it 'check sysconfig http2 configuration is enabled' do
          service_file = '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf'
          is_expected.to contain_file(service_file).with(
            content: %r{^Environment="STORM_WEBDAV_ENABLE_HTTP2=true"},
          )
        end
      end

      context 'Check sysconfig debug enabled with custom port but not suspended' do
        let(:params) do
          {
            'debug' => true,
            'debug_port' => 1234,
            'debug_suspend' => false,
          }
        end

        it 'check service file' do
          service_file = '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf'
          is_expected.to contain_file(service_file).with(
            ensure: 'file',
          )
          is_expected.to contain_file(service_file).with(
            content: %r{^Environment="STORM_WEBDAV_JVM_OPTS=-Xms1024m -Xmx1024m -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=1234,suspend=n"},
          )
        end
      end

      context 'Check sysconfig debug enabled with default port and also suspended' do
        let(:params) do
          {
            'debug' => true,
            'debug_suspend' => true,
          }
        end

        it 'check sysconfig file' do
          service_file = '/etc/systemd/system/storm-webdav.service.d/storm-webdav.conf'
          is_expected.to contain_file(service_file).with(
            ensure: 'file',
          )
          is_expected.to contain_file(service_file).with(
            content: %r{^Environment="STORM_WEBDAV_JVM_OPTS=-Xms1024m -Xmx1024m -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=1044,suspend=y"},
          )
        end
      end
    end
  end
end
