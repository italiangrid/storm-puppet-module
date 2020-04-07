require 'spec_helper'

describe 'storm::webdav', :type => :class do

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
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'authenticated_read_enabled' => true,
                'anonymous_read_enabled' => false,
                'vo_map_enabled' => true,
                'vo_map_grants_write_permission' => false,
                'orgs_grant_write_permission' => false,
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'access_points' => ['/atlas', '/atlasdisk'],
                'vos' => ['atlas'],
                'orgs' => ['atlas'],
                'authenticated_read_enabled' => false,
                'anonymous_read_enabled' => true,
                'vo_map_enabled' => false,
              },
            ],
            'oauth_issuers' => [
              {
                'name' => 'iam-virgo',
                'issuer' => 'https://iam-virgo.cloud.cnaf.infn.it/',
              },
              {
                'name' => 'indigo-dc',
                'issuer' => 'https://iam-test.indigo-datacloud.eu/',
              },
            ],
            'hostnames' => ['storm-w1.example', 'storm-w2.example'],
            'http_port' => 8080,
            'https_port' => 9443,
            'max_concurrent_connections' => 200,
            'max_queue_size' => 700,
            'connector_max_idle_time' => 15000,
            'vo_map_files_enable' => true,
            'vo_map_files_refresh_interval' => 22000,
            'trust_anchors_refresh_interval' => 80000,

            'tpc_max_connections' => 100,
            'tpc_verify_checksum' => true,

            'jvm_opts' => '-Xms512m -Xmx1024m',

            'authz_server_enable' => true,
            'authz_server_issuer' => 'https://storm-w1.example:9443',
            'authz_server_max_token_lifetime_sec' => 43400,
            'authz_server_secret' => 'secret',
            'require_client_cert' => true,
            'storm_limit_nofile' => 1046,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it "check storm-webdav host certificate and key" do

          is_expected.to contain_file('/etc/grid-security/storm-webdav').with( 
            :ensure => 'directory',
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0755',
          )
          is_expected.to contain_file('/etc/grid-security/storm-webdav/hostcert.pem').with( 
            :ensure => 'present',
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0644',
          )
          is_expected.to contain_file('/etc/grid-security/storm-webdav/hostkey.pem').with( 
            :ensure => 'present',
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0400',
          )
        end

        it "check java.io.tmpdir exists" do
          is_expected.to contain_file('/var/lib/storm-webdav/work').with(
            :ensure => 'directory',
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0755',
          )
        end

        it "check storage area properties files" do
          # test.vo properties
          testvo_props='/etc/storm/webdav/sa.d/test.vo.properties'
          is_expected.to contain_file(testvo_props).with( 
            :ensure => 'present',
          )
          is_expected.to contain_file(testvo_props).with( :content => /name=test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /rootPath=\/storage\/test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /accessPoints=\/test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /vos=test.vo,test.vo.2/ )
          is_expected.not_to contain_file(testvo_props).with( :content => /orgs=/ )
          is_expected.to contain_file(testvo_props).with( :content => /authenticatedReadEnabled=true/ )
          is_expected.to contain_file(testvo_props).with( :content => /anonymousReadEnabled=false/ )
          is_expected.to contain_file(testvo_props).with( :content => /voMapEnabled=true/ )
          is_expected.to contain_file(testvo_props).with( :content => /voMapGrantsWritePermission=false/ )
          is_expected.to contain_file(testvo_props).with( :content => /orgsGrantWritePermission=false/ )
          is_expected.to contain_file(testvo_props).that_notifies(['Service[storm-webdav]'])
          # atlas properties
          atlas_props='/etc/storm/webdav/sa.d/atlas.properties'
          is_expected.to contain_file(atlas_props).with(
            :ensure => 'present',
          )
          is_expected.to contain_file(atlas_props).with( :content => /name=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /rootPath=\/storage\/atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /accessPoints=\/atlas,\/atlasdisk/ )
          is_expected.to contain_file(atlas_props).with( :content => /vos=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /orgs=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /authenticatedReadEnabled=false/ )
          is_expected.to contain_file(atlas_props).with( :content => /anonymousReadEnabled=true/ )
          is_expected.to contain_file(atlas_props).with( :content => /voMapEnabled=false/ )
          is_expected.not_to contain_file(atlas_props).with( :content => /voMapGrantsWritePermission=/ )
          is_expected.not_to contain_file(atlas_props).with( :content => /orgsGrantWritePermission=/ )
          is_expected.to contain_file(atlas_props).that_notifies(['Service[storm-webdav]'])
        end

        it "check application.yml" do
        
          app_title='/etc/storm/webdav/config/application.yml'

          is_expected.to contain_file(app_title).with({
            :ensure => 'present',
          })
          is_expected.to contain_file(app_title).with({
            :content => /iam-virgo/,
          })
          is_expected.to contain_file(app_title).with({
            :content => /https:\/\/iam-virgo.cloud.cnaf.infn.it\//,
          })
          is_expected.to contain_file(app_title).with({
            :content => /indigo-dc/,
          })
          is_expected.to contain_file(app_title).with({
            :content => /https:\/\/iam-test.indigo-datacloud.eu\//,
          })
          is_expected.to contain_file(app_title).that_notifies(['Service[storm-webdav]'])
          
        end

        it "check sysconfig file" do
          sysconfig_file='/etc/sysconfig/storm-webdav'
          is_expected.to contain_file(sysconfig_file).with(
            :ensure => 'present',
          )
          is_expected.to contain_file(sysconfig_file).that_notifies(['Service[storm-webdav]'])
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_USER="storm"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_HOSTNAME_0=storm-w1.example/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_HOSTNAME_1=storm-w2.example/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_HTTP_PORT=8080/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_HTTPS_PORT=9443/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_CERTIFICATE_PATH="\/etc\/grid-security\/storm-webdav\/hostcert.pem"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_PRIVATE_KEY_PATH="\/etc\/grid-security\/storm-webdav\/hostkey.pem"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_MAX_CONNECTIONS=200/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_MAX_QUEUE_SIZE=700/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_SA_CONFIG_DIR="\/etc\/storm\/webdav\/sa.d"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_VO_MAP_FILES_ENABLE="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_VO_MAP_FILES_CONFIG_DIR="\/etc\/storm\/webdav\/vo-mapfiles.d"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_VO_MAP_FILES_REFRESH_INTERVAL="22000"/)
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_LOG="\/var\/log\/storm\/webdav\/storm-webdav-server.log"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_LOG_CONFIGURATION="\/etc\/storm\/webdav\/logback.xml"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_ACCESS_LOG_CONFIGURATION="\/etc\/storm\/webdav\/logback-access.xml"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_CONNECTOR_MAX_IDLE_TIME=15000/)
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_TRUST_ANCHORS_DIR="\/etc\/grid-security\/certificates"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_TRUST_ANCHORS_REFRESH_INTERVAL=80000/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_TPC_MAX_CONNECTIONS="100"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_TPC_VERIFY_CHECKSUM="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_JVM_OPTS="-Xms512m -Xmx1024m"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_AUTHZ_SERVER_ENABLE="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_AUTHZ_SERVER_ISSUER="https:\/\/storm-w1.example:9443"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_AUTHZ_SERVER_MAX_TOKEN_LIFETIME_SEC="43400"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_AUTHZ_SERVER_SECRET="secret"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_REQUIRE_CLIENT_CERT="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_USE_CONSCRYPT="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_TPC_USE_CONSCRYPT="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_ENABLE_HTTP2="true"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^# STORM_WEBDAV_DEBUG="y"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^# STORM_WEBDAV_DEBUG_PORT=1044/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^# STORM_WEBDAV_DEBUG_SUSPEND="y"/ )

        end

        it "check storm-webdav.service.d exists" do
          is_expected.to contain_file('/etc/systemd/system/storm-webdav.service.d').with(
            :ensure => 'directory',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644',
          )
        end

        it "check storm-webdav.service.d/filelimit.conf exists" do
          limit_file='/etc/systemd/system/storm-webdav.service.d/filelimit.conf'
          is_expected.to contain_file(limit_file).with(
            :ensure  => 'present',
            :owner   => 'root',
            :group   => 'root',
            :mode    => '0644',
            :content => /^LimitNOFILE=1046/,
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

        it "check sysconfig file" do
          sysconfig_file='/etc/sysconfig/storm-webdav'
          is_expected.to contain_file(sysconfig_file).with(
            :ensure => 'present',
          )
          is_expected.to contain_file(sysconfig_file).with( :content => /^STORM_WEBDAV_DEBUG="y"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^STORM_WEBDAV_DEBUG_PORT=1234/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^# STORM_WEBDAV_DEBUG_SUSPEND="y"/ )
        end
      end

      context 'Check sysconfig debug enabled with default port and also suspended' do

        let(:params) do 
          {
            'debug' => true,
            'debug_suspend' => true,
          }
        end

        it "check sysconfig file" do
          sysconfig_file='/etc/sysconfig/storm-webdav'
          is_expected.to contain_file(sysconfig_file).with(
            :ensure => 'present',
          )
          is_expected.to contain_file(sysconfig_file).with( :content => /^STORM_WEBDAV_DEBUG="y"/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^STORM_WEBDAV_DEBUG_PORT=1044/ )
          is_expected.to contain_file(sysconfig_file).with( :content => /^STORM_WEBDAV_DEBUG_SUSPEND="y"/ )
        end
      end
    end
  end
end