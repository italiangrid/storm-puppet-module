require 'spec_helper'

describe 'storm::backend', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:params) do 
        {
          'hostname' => 'storm.example.org',
        }
      end
      let(:facts) do
        facts
      end

      context 'with custom backend params' do

        let(:params) do
          super().merge({
            'install_native_libs_gpfs' => true,
            'frontend_public_host' => 'frontend.example.org',
            'db_username' => 'test',
            'db_password' => 'secret',
            'gsiftp_pool_members' => [
              {
                'hostname' => 'gridftp-0.example.org',
              }, {
                'hostname' => 'gridftp-1.example.org',
              }
            ],
            'webdav_pool_members' => [
              {
                'hostname' => 'webdav-0.example.org',
              }, {
                'hostname' => 'webdav-1.example.org',
              }
            ],
            'srm_pool_members' => [
              {
                'hostname' => 'frontend-0.example.org',
                'port' => 8445,
              }, {
                'hostname' => 'frontend-1.example.org',
              }
            ],
            'transfer_protocols' => ['file','gsiftp','webdav'],
            'storage_areas'       => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'storage_class' => 'T0D1',
                'online_size' => 4,
                'transfer_protocols' => ['file','gsiftp','webdav','xroot'],
                'default_acl_list' => [
                  {
                    'group'      => 'test.vo',
                    'permission' => 'R',
                  },
                ],
        
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'access_points' => ['/atlas', '/atlasdisk'],
                'vos' => ['atlas'],
                'fs_type' => 'gpfs',
                'storage_class' => 'T1D0',
                'online_size' => 4,
                'nearline_size' => 10,
                'gsiftp_pool_balance_strategy' => 'weight',
                'gsiftp_pool_members' => [
                  {
                    'hostname' => 'gridftp-0.example.org',
                    'weight' => 50,
                  }, {
                    'hostname' => 'gridftp-1.example.org',
                  }
                ],
                'default_acl_list'   => [
                  {
                    'group'      => 'atlasusers',
                    'permission' => 'RW',
                  },
                  {
                    'group'      => 'atlasprod',
                    'permission' => 'RW',
                  },
                ],
              },
              {
                'name' => 'novos',
                'root_path' => '/storage/novos',
                'access_points' => ['/novos'],
                'vos' => [],
                'online_size' => 4,
              }
            ],
            'info_sitename' => 'test',
            'info_storage_default_root' => '/another-storage',
            'info_endpoint_quality_level' => 1,
            'jvm_options' => '-Xms512m -Xmx1024m',
            'storm_limit_nofile' => 15535,
          })
        end

        it "check backend namespace file content" do
          title='/etc/storm/backend-server/namespace.xml'
          is_expected.to contain_file(title).with( 
            :ensure  => 'present',
            :content => my_fixture_read("namespace-0.xml"),
          )
        end

        it "check backend storm.properties file content" do
          title='/etc/storm/backend-server/storm.properties'
          is_expected.to contain_file(title).with( 
            :ensure  => 'present',
          )
          is_expected.to contain_file(title).with( :content => /storm.service.FE-public.hostname=frontend.example.org/ )
          is_expected.to contain_file(title).with( :content => /storm.service.port=8444/ )
          is_expected.to contain_file(title).with( :content => /storm.service.SURL.endpoint=srm:\/\/frontend-0.example.org:8445\/srm\/managerv2,srm:\/\/frontend-1.example.org:8444\/srm\/managerv2/ )
          is_expected.to contain_file(title).with( :content => /storm.service.SURL.default-ports=8445,8444/ )
          is_expected.to contain_file(title).with( :content => /storm.service.request-db.host=storm.example.org/ )
          is_expected.to contain_file(title).with( :content => /storm.service.request-db.username=test/ )
          is_expected.to contain_file(title).with( :content => /storm.service.request-db.passwd=secret/ )
          is_expected.to contain_file(title).with( :content => /directory.automatic-creation=false/ )
          is_expected.to contain_file(title).with( :content => /directory.writeperm=false/ )
          is_expected.to contain_file(title).with( :content => /ptg.skip-acl-setup=false/ )
          is_expected.to contain_file(title).with( :content => /pinLifetime.default=259200/ )
          is_expected.to contain_file(title).with( :content => /pinLifetime.maximum=1814400/ )
          is_expected.to contain_file(title).with( :content => /sanity-check.enabled=true/ )
          is_expected.to contain_file(title).with( :content => /storm.service.du.enabled=false/ )
          is_expected.to contain_file(title).with( :content => /storm.service.du.delay=60/ )
          is_expected.to contain_file(title).with( :content => /storm.service.du.interval=360/ )
          is_expected.to contain_file(title).with( :content => /synchcall.directoryManager.maxLsEntry=2000/ )
          is_expected.to contain_file(title).with( :content => /gc.pinnedfiles.cleaning.delay=10/ )
          is_expected.to contain_file(title).with( :content => /gc.pinnedfiles.cleaning.interval=300/ )
          is_expected.to contain_file(title).with( :content => /purging=true/ )
          is_expected.to contain_file(title).with( :content => /purge.interval=600/ )
          is_expected.to contain_file(title).with( :content => /purge.size=800/ )
          is_expected.to contain_file(title).with( :content => /expired.request.time=21600/ )
          is_expected.to contain_file(title).with( :content => /transit.interval=300/ )
          is_expected.to contain_file(title).with( :content => /transit.delay=10/ )
          is_expected.to contain_file(title).with( :content => /extraslashes.file=/ )
          is_expected.to contain_file(title).with( :content => /extraslashes.root=\// )
          is_expected.to contain_file(title).with( :content => /extraslashes.gsiftp=\// )
          is_expected.to contain_file(title).with( :content => /persistence.internal-db.connection-pool=true/ )
          is_expected.to contain_file(title).with( :content => /persistence.internal-db.connection-pool.maxActive=200/ )
          is_expected.to contain_file(title).with( :content => /persistence.internal-db.connection-pool.maxWait=50/ )
          is_expected.to contain_file(title).with( :content => /asynch.db.ReconnectPeriod=18000/ )
          is_expected.to contain_file(title).with( :content => /asynch.db.DelayPeriod=30/ )
          is_expected.to contain_file(title).with( :content => /asynch.PickingInitialDelay=1/ )
          is_expected.to contain_file(title).with( :content => /asynch.PickingTimeInterval=2/ )
          is_expected.to contain_file(title).with( :content => /asynch.PickingMaxBatchSize=100/ )
          is_expected.to contain_file(title).with( :content => /synchcall.directoryManager.maxLsEntry=2000/ )
          is_expected.to contain_file(title).with( :content => /storm.rest.services.port=9998/ )
          is_expected.to contain_file(title).with( :content => /storm.rest.services.maxthreads=100/ )
          is_expected.to contain_file(title).with( :content => /storm.rest.services.max_queue_size=1000/ )
          is_expected.to contain_file(title).with( :content => /synchcall.xmlrpc.unsecureServerPort=8080/ )
          is_expected.to contain_file(title).with( :content => /synchcall.xmlrpc.maxthread=256/ )
          is_expected.to contain_file(title).with( :content => /synchcall.xmlrpc.max_queue_size=1000/ )
          is_expected.to contain_file(title).with( :content => /synchcall.xmlrpc.security.enabled=true/ )
          is_expected.to contain_file(title).with( :content => /synchcall.xmlrpc.security.token=secret/ )

          is_expected.to contain_file(title).with( :content => /gc.pinnedfiles.cleaning.delay=10/ )
          is_expected.to contain_file(title).with( :content => /gc.pinnedfiles.cleaning.interval=300/ )
          is_expected.to contain_file(title).with( :content => /purging=true/ )
          is_expected.to contain_file(title).with( :content => /purge.interval=600/ )
          is_expected.to contain_file(title).with( :content => /purge.size=800/ )
          is_expected.to contain_file(title).with( :content => /expired.request.time=21600/ )
          is_expected.to contain_file(title).with( :content => /expired.inprogress.time=2592000/ )
          is_expected.to contain_file(title).with( :content => /transit.interval=300/ )
          is_expected.to contain_file(title).with( :content => /transit.delay=10/ )
          is_expected.to contain_file(title).with( :content => /ptg.skip-acl-setup=false/ )
          is_expected.to contain_file(title).with( :content => /http.turl_prefix=/ )

          # is_expected.to contain_file(title).with( :content => // )
          # is_expected.to contain_file(title).with( :content => // )
        end

        it "check info provider configuration file content" do
          title='/etc/storm/info-provider/storm-yaim-variables.conf'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
          )
          is_expected.to contain_file(title).with( :content => /SITE_NAME=test/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PUBLIC_HOST=frontend.example.org/ )
          is_expected.to contain_file(title).with( :content => /STORM_BACKEND_HOST=storm.example.org/ )
          is_expected.to contain_file(title).with( :content => /STORM_DEFAULT_ROOT=\/another-storage/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PATH=\/srm\/managerv2/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PORT=8444/ )
          is_expected.to contain_file(title).with( :content => /STORM_BACKEND_REST_SERVICES_PORT=9998/ )
          is_expected.to contain_file(title).with( :content => /STORM_ENDPOINT_QUALITY_LEVEL=1/ )

          is_expected.to contain_file(title).with( :content => /STORM_INFO_FILE_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_RFIO_SUPPORT=false/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_GRIDFTP_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_ROOT_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_HTTP_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_HTTPS_SUPPORT=true/ )

          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_HOST_LIST=frontend-0.example.org,frontend-1.example.org/ )

          is_expected.to contain_file(title).with( :content => /STORM_WEBDAV_POOL_LIST=http:\/\/webdav-0.example.org:8085\/,https:\/\/webdav-0.example.org:8443\/,http:\/\/webdav-1.example.org:8085\/,https:\/\/webdav-1.example.org:8443\// )

          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_VONAME='test.vo test.vo.2'/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ONLINE_SIZE=4/ )
          is_expected.not_to contain_file(title).with( :content => /STORM_TESTVO_NEARLINE_SIZE=0/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_TOKEN=TESTVO-TOKEN/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ROOT=\/storage\/test.vo/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_STORAGECLASS=T0D1/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ACCESSPOINT='\/test.vo'/ )

          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_VONAME='atlas'/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ONLINE_SIZE=4/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_NEARLINE_SIZE=10/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_TOKEN=ATLAS-TOKEN/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ROOT=\/storage\/atlas/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_STORAGECLASS=T1D0/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ACCESSPOINT='\/atlas \/atlasdisk'/ )

          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_VONAME='*'/ )
          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_ONLINE_SIZE=4/ )
          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_TOKEN=NOVOS-TOKEN/ )
          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_ROOT=\/storage\/novos/ )
          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_STORAGECLASS=T0D1/ )
          is_expected.to contain_file(title).with( :content => /STORM_NOVOS_ACCESSPOINT='\/novos'/ )

          is_expected.to contain_file(title).with( :content => /STORM_STORAGEAREA_LIST='test.vo atlas novos'/ )
          is_expected.to contain_file(title).with( :content => /VOS='test.vo test.vo.2 atlas'/ )
        end

        it "check if exec of storm-info-provider configure has been run" do
          is_expected.to contain_exec('configure-info-provider')
        end
  
        it "check if exec of storm-info-provider configure has been run" do
          is_expected.to contain_exec('configure-info-provider')
        end

        it "check service file content" do
          title='/etc/systemd/system/storm-backend-server.service.d/storm-backend-server.conf'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
          )
          is_expected.to contain_file(title).with( :content => /^Environment="STORM_BE_JVM_OPTS=-Xms512m -Xmx1024m"/ )
          is_expected.to contain_file(title).with( :content => /^Environment="LCMAPS_DB_FILE=\/etc\/storm\/backend-server\/lcmaps.db"/ )
          is_expected.to contain_file(title).with( :content => /^Environment="LCMAPS_POLICY_NAME=standard"/ )
          is_expected.to contain_file(title).with( :content => /^Environment="LCMAPS_LOG_FILE=\/var\/log\/storm\/lcmaps.log"/ )
          is_expected.to contain_file(title).with( :content => /^Environment="LCMAPS_DEBUG_LEVEL=0"/ )
        end

        it "check service file limit content" do
          title='/etc/systemd/system/storm-backend-server.service.d/filelimit.conf'
          is_expected.to contain_file(title).with(
            :ensure => 'present',
          )
          is_expected.to contain_file(title).with( :content => /^LimitNOFILE=15535/ )
        end

        it "check db scripts exist" do
          storm_db='/tmp/storm_db.sql'
          is_expected.to contain_file(storm_db).with( 
            :ensure => 'present',
          )
          storm_be_isam='/tmp/storm_be_ISAM.sql'
          is_expected.to contain_file(storm_be_isam).with( 
            :ensure => 'present',
          )
        end

        it "check storm db creation" do
          is_expected.to contain_exec('storm_db-import')
        end

        it "check storm be ISAM db creation" do
          is_expected.to contain_exec('storm_be_ISAM-import')
        end

        it "check path-authz.db file not initialized" do
          is_expected.not_to contain_file('/etc/storm/backend-server/path-authz.db')
        end

        context 'test path authz db' do

          let(:params) do
            super().merge({
              'manage_path_authz_db' => true,
            })
          end
  
          it "check path-authz.db file" do
            is_expected.to contain_file('/etc/storm/backend-server/path-authz.db').with(
              :ensure => 'present',
              :owner  => 'root',
              :group  => 'storm',
              :mode   => '0644',
            )
          end
        end

      end

    end
  end
end