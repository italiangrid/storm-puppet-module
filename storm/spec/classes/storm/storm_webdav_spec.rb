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
            'user_name' => 'test',
            'storage_areas' => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'authenticated_read_enabled' => true,
                'anonymous_read_enabled' => false,
                'vo_map_enabled' => true,
                'vo_map_grants_write_access' => false,
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
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('storm-webdav').with(ensure: 'installed') }
        it { is_expected.to contain_service('storm-webdav').with(ensure: 'running') }
  
        it "check host certificate directory" do
          is_expected.to contain_file('/etc/grid-security/storm-webdav').with( 
              :ensure => 'directory',
              :owner  => 'test',
              :group  => 'test',
              :mode   => '0755',
          )
        end
  
        it "check hostcert.pem" do
            is_expected.to contain_file('/etc/grid-security/storm-webdav/hostcert.pem').with( 
                :ensure => 'present',
                :owner  => 'test',
                :group  => 'test',
                :mode   => '0644',
            )
        end
  
        it "check hostkey.pem" do
            is_expected.to contain_file('/etc/grid-security/storm-webdav/hostkey.pem').with( 
                :ensure => 'present',
                :owner  => 'test',
                :group  => 'test',
                :mode   => '0400',
            )
        end

        it "check storm webdav configuration directory" do
          is_expected.to contain_file('/etc/storm/webdav').with( 
            :owner  => 'root',
            :group  => 'test',
            :mode   => '0750',
            :ensure => 'directory'
          )
        end

        it "check storm webdav application configuration directory" do
          is_expected.to contain_file('/etc/storm/webdav/config').with( 
            :owner  => 'root',
            :group  => 'test',
            :mode   => '0750',
            :ensure => 'directory'
          )
        end

        it "check storage area configuration directory" do
          is_expected.to contain_file('/etc/storm/webdav/sa.d').with( 
            :owner  => 'root',
            :group  => 'test',
            :mode   => '0750',
            :ensure => 'directory'
          )
        end

        it "check storage area properties files" do
          # test.vo properties
          testvo_props='/etc/storm/webdav/sa.d/test.vo.properties'
          is_expected.to contain_file(testvo_props).with( :ensure => 'present' )
          is_expected.to contain_file(testvo_props).with( :content => /name=test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /rootPath=\/storage\/test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /accessPoints=\/test.vo/ )
          is_expected.to contain_file(testvo_props).with( :content => /vos=test.vo,test.vo.2/ )
          is_expected.not_to contain_file(testvo_props).with( :content => /orgs=/ )
          is_expected.to contain_file(testvo_props).with( :content => /authenticatedReadEnabled=true/ )
          is_expected.to contain_file(testvo_props).with( :content => /anonymousReadEnabled=false/ )
          is_expected.to contain_file(testvo_props).with( :content => /voMapEnabled=true/ )
          is_expected.to contain_file(testvo_props).with( :content => /voMapGrantsWriteAccess=false/ )
          # atlas properties
          atlas_props='/etc/storm/webdav/sa.d/atlas.properties'
          is_expected.to contain_file(atlas_props).with( :ensure => 'present' )
          is_expected.to contain_file(atlas_props).with( :content => /name=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /rootPath=\/storage\/atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /accessPoints=\/atlas,\/atlasdisk/ )
          is_expected.to contain_file(atlas_props).with( :content => /vos=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /orgs=atlas/ )
          is_expected.to contain_file(atlas_props).with( :content => /authenticatedReadEnabled=false/ )
          is_expected.to contain_file(atlas_props).with( :content => /anonymousReadEnabled=true/ )
          is_expected.to contain_file(atlas_props).with( :content => /voMapEnabled=false/ )
          is_expected.not_to contain_file(atlas_props).with( :content => /voMapGrantsWriteAccess=/ )
        end

        it "check application.yml" do
        
          is_expected.to contain_file('/etc/storm/webdav/config/application.yml').with({
            :content => /iam-virgo/,
          })
          is_expected.to contain_file('/etc/storm/webdav/config/application.yml').with({
            :content => /https:\/\/iam-virgo.cloud.cnaf.infn.it\//,
          })
          is_expected.to contain_file('/etc/storm/webdav/config/application.yml').with({
            :content => /indigo-dc/,
          })
          is_expected.to contain_file('/etc/storm/webdav/config/application.yml').with({
            :content => /https:\/\/iam-test.indigo-datacloud.eu\//,
          })
          
        end

        it "check sysconfig file" do
          sysconfig_file='/etc/sysconfig/storm-webdav'
          is_expected.to contain_file(sysconfig_file).with( :ensure => 'present' )
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_WEBDAV_USER=test/ )
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

        end

        it "check systemd unit file" do
          unit_file='/etc/systemd/system/storm-webdav.service'
          case facts[:operatingsystemmajrelease]
          when '7'
            is_expected.to contain_file(unit_file).with( :ensure => 'present' )
            is_expected.to contain_file(unit_file).with( :content => /User=test/ )
            is_expected.to contain_file(unit_file).with( :content => /EnvironmentFile=-\/etc\/sysconfig\/storm-webdav/ )
            is_expected.to contain_file(unit_file).with( :content => /WorkingDirectory=\/etc\/storm\/webdav/ )
          else
            is_expected.not_to contain_file(unit_file)
          end
        end
      end
    end
  end
end