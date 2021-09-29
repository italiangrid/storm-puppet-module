require 'spec_helper'

describe 'storm::backend', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      hostname = facts[:hostname]

      context 'with storm.properties managed as a source' do
        let(:params) do
          {
            'storm_properties_file' => '/path/to/storm.properties',
          }
        end

        it 'check storm.properties source' do
          title = '/etc/storm/backend-server/storm.properties'
          is_expected.to contain_file(title).with(
            ensure: 'present',
            source: '/path/to/storm.properties',
          )
        end
      end

      context 'use default configuration' do

        it 'check backend storm.properties file content' do
          title = '/etc/storm/backend-server/storm.properties'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{db.username: storm})
          is_expected.to contain_file(title).with(content: %r{db.password: storm})
          is_expected.to contain_file(title).with(content: %r{db.hostname: #{hostname}})
          is_expected.to contain_file(title).with(content: %r{db.port: 3306})
          is_expected.to contain_file(title).with(content: %r{db.properties: serverTimezone=UTC&autoReconnect=true})
          is_expected.to contain_file(title).with(content: %r{db.pool.size: -1})
          is_expected.to contain_file(title).with(content: %r{db.pool.min_idle: 10})
          is_expected.to contain_file(title).with(content: %r{db.pool.max_wait_millis: 5000})
          is_expected.to contain_file(title).with(content: %r{db.pool.test_on_borrow: true})
          is_expected.to contain_file(title).with(content: %r{db.pool.test_while_idle: true})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[0\].host: #{hostname}})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[0\].port: 8444})
          is_expected.to contain_file(title).with(content: %r{rest.port: 9998})
          is_expected.to contain_file(title).with(content: %r{rest.max_threads: 100})
          is_expected.to contain_file(title).with(content: %r{rest.max_queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.port: 8080})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.max_threads: 256})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.max_queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{sanity_checks_enabled: true})
          is_expected.to contain_file(title).with(content: %r{du.enabled: false})
          is_expected.to contain_file(title).with(content: %r{du.initial_delay: 60})
          is_expected.to contain_file(title).with(content: %r{du.tasks_interval: 86400})
          is_expected.to contain_file(title).with(content: %r{du.parallel_tasks_enabled: false})
          is_expected.to contain_file(title).with(content: %r{security.enabled: true})
          is_expected.to contain_file(title).with(content: %r{security.token: secret})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.interval: 300})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.ptp_expiration_time: 2592000})
          is_expected.to contain_file(title).with(content: %r{expired_spaces_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{expired_spaces_agent.interval: 300})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.enabled: true})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.interval: 600})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.purge_size: 800})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.purge_age: 21600})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.delay: 1})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.interval: 2})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.max_fetched_size: 100})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.core_pool_size: 10})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.max_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{extraslashes.file: })
          is_expected.to contain_file(title).with(content: %r{extraslashes.rfio: })
          is_expected.to contain_file(title).with(content: %r{extraslashes.gsiftp: /})
          is_expected.to contain_file(title).with(content: %r{extraslashes.root: /})
          is_expected.to contain_file(title).with(content: %r{synch_ls.max_entries: 2000})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_all_level_recursive: false})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_num_levels: 1})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_offset: 0})
        end
      end

      context 'with custom backend params' do
        let(:params) do
          {
            'db_username' => 'test',
            'db_pool_size' => 200,
            'xroot_hostname' => 'storm.example.org',
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
              }, {
                'hostname' => 'webdav-2.example.org',
                'published' => false,
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
            'transfer_protocols' => ['file', 'gsiftp', 'webdav'],
            'storage_areas' => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'vos' => ['test.vo', 'test.vo.2'],
                'storage_class' => 'T0D1',
                'online_size' => 4,
                'transfer_protocols' => ['file', 'gsiftp', 'webdav', 'xroot'],
                'default_acl_list' => [
                  {
                    'group' => 'test.vo',
                    'permission' => 'R',
                  },
                ],
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'access_points' => ['/atlas', '/atlasdisk'],
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
                'default_acl_list' => [
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
                'vos' => [],
                'online_size' => 4,
              },
            ],
            'info_sitename' => 'test',
            'info_storage_default_root' => '/another-storage',
            'info_endpoint_quality_level' => 1,
            'jvm_options' => '-Xms512m -Xmx1024m',
            'storm_limit_nofile' => 15_535,
          }
        end

        it 'config class is used' do
          is_expected.to contain_class('storm::backend::config')
          is_expected.to contain_class('storm::backend::configdb')
        end

        it 'check backend namespace file content' do
          title = '/etc/storm/backend-server/namespace.xml'
          is_expected.to contain_file(title).with(
            ensure: 'present',
            content: my_fixture_read('namespace-0.xml'),
          )
        end

        it 'check backend storm.properties file content' do
          title = '/etc/storm/backend-server/storm.properties'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{db.username: test})
          is_expected.to contain_file(title).with(content: %r{db.password: storm})
          is_expected.to contain_file(title).with(content: %r{db.hostname: #{hostname}})
          is_expected.to contain_file(title).with(content: %r{db.port: 3306})
          is_expected.to contain_file(title).with(content: %r{db.properties: serverTimezone=UTC&autoReconnect=true})
          is_expected.to contain_file(title).with(content: %r{db.pool.size: 200})
          is_expected.to contain_file(title).with(content: %r{db.pool.min_idle: 10})
          is_expected.to contain_file(title).with(content: %r{db.pool.max_wait_millis: 5000})
          is_expected.to contain_file(title).with(content: %r{db.pool.test_on_borrow: true})
          is_expected.to contain_file(title).with(content: %r{db.pool.test_while_idle: true})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[0\].host: frontend-0.example.org})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[0\].port: 8445})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[1\].host: frontend-1.example.org})
          is_expected.to contain_file(title).with(content: %r{srm_endpoints\[1\].port: 8444})
          is_expected.to contain_file(title).with(content: %r{rest.port: 9998})
          is_expected.to contain_file(title).with(content: %r{rest.max_threads: 100})
          is_expected.to contain_file(title).with(content: %r{rest.max_queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.port: 8080})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.max_threads: 256})
          is_expected.to contain_file(title).with(content: %r{xmlrpc.max_queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{sanity_checks_enabled: true})
          is_expected.to contain_file(title).with(content: %r{du.enabled: false})
          is_expected.to contain_file(title).with(content: %r{du.initial_delay: 60})
          is_expected.to contain_file(title).with(content: %r{du.tasks_interval: 86400})
          is_expected.to contain_file(title).with(content: %r{du.parallel_tasks_enabled: false})
          is_expected.to contain_file(title).with(content: %r{security.enabled: true})
          is_expected.to contain_file(title).with(content: %r{security.token: secret})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.interval: 300})
          is_expected.to contain_file(title).with(content: %r{inprogress_requests_agent.ptp_expiration_time: 2592000})
          is_expected.to contain_file(title).with(content: %r{expired_spaces_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{expired_spaces_agent.interval: 300})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.enabled: true})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.delay: 10})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.interval: 600})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.purge_size: 800})
          is_expected.to contain_file(title).with(content: %r{completed_requests_agent.purge_age: 21600})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.delay: 1})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.interval: 2})
          is_expected.to contain_file(title).with(content: %r{requests_picker_agent.max_fetched_size: 100})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.core_pool_size: 10})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.max_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{requests_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{ptp_scheduler.queue_size: 1000})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{ptg_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.core_pool_size: 50})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.max_pool_size: 200})
          is_expected.to contain_file(title).with(content: %r{bol_scheduler.queue_size: 2000})
          is_expected.to contain_file(title).with(content: %r{extraslashes.file: })
          is_expected.to contain_file(title).with(content: %r{extraslashes.rfio: })
          is_expected.to contain_file(title).with(content: %r{extraslashes.gsiftp: /})
          is_expected.to contain_file(title).with(content: %r{extraslashes.root: /})
          is_expected.to contain_file(title).with(content: %r{synch_ls.max_entries: 2000})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_all_level_recursive: false})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_num_levels: 1})
          is_expected.to contain_file(title).with(content: %r{synch_ls.default_offset: 0})
        end

        it 'check info provider configuration file content' do
          title = '/etc/storm/info-provider/storm-yaim-variables.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{SITE_NAME=test})
          is_expected.to contain_file(title).with(content: %r{STORM_FRONTEND_PUBLIC_HOST=frontend-0.example.org})
          is_expected.to contain_file(title).with(content: %r{STORM_BACKEND_HOST=#{hostname}})
          is_expected.to contain_file(title).with(content: %r{STORM_DEFAULT_ROOT=\/another-storage})
          is_expected.to contain_file(title).with(content: %r{STORM_FRONTEND_PATH=\/srm\/managerv2})
          is_expected.to contain_file(title).with(content: %r{STORM_FRONTEND_PORT=8445})
          is_expected.to contain_file(title).with(content: %r{STORM_BACKEND_REST_SERVICES_PORT=9998})
          is_expected.to contain_file(title).with(content: %r{STORM_ENDPOINT_QUALITY_LEVEL=1})

          is_expected.to contain_file(title).with(content: %r{STORM_INFO_FILE_SUPPORT=true})
          is_expected.to contain_file(title).with(content: %r{STORM_INFO_RFIO_SUPPORT=false})
          is_expected.to contain_file(title).with(content: %r{STORM_INFO_GRIDFTP_SUPPORT=true})
          is_expected.to contain_file(title).with(content: %r{STORM_INFO_ROOT_SUPPORT=true})
          is_expected.to contain_file(title).with(content: %r{STORM_INFO_HTTP_SUPPORT=true})
          is_expected.to contain_file(title).with(content: %r{STORM_INFO_HTTPS_SUPPORT=true})

          is_expected.to contain_file(title).with(content: %r{STORM_FRONTEND_HOST_LIST=frontend-0.example.org,frontend-1.example.org})

          is_expected.to contain_file(title).with(
            content: %r{STORM_WEBDAV_POOL_LIST=http:\/\/webdav-0.example.org:8085\/,https:\/\/webdav-0.example.org:8443\/,http:\/\/webdav-1.example.org:8085\/,https:\/\/webdav-1.example.org:8443\/},
          )

          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_VONAME='test.vo test.vo.2'})
          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_ONLINE_SIZE=4})
          is_expected.not_to contain_file(title).with(content: %r{STORM_TESTVO_NEARLINE_SIZE=0})
          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_TOKEN=TESTVO-TOKEN})
          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_ROOT=\/storage\/test.vo})
          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_STORAGECLASS=T0D1})
          is_expected.to contain_file(title).with(content: %r{STORM_TESTVO_ACCESSPOINT='\/test.vo'})

          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_VONAME='atlas'})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_ONLINE_SIZE=4})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_NEARLINE_SIZE=10})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_TOKEN=ATLAS-TOKEN})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_ROOT=\/storage\/atlas})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_STORAGECLASS=T1D0})
          is_expected.to contain_file(title).with(content: %r{STORM_ATLAS_ACCESSPOINT='\/atlas \/atlasdisk'})

          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_VONAME='*'})
          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_ONLINE_SIZE=4})
          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_TOKEN=NOVOS-TOKEN})
          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_ROOT=\/storage\/novos})
          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_STORAGECLASS=T0D1})
          is_expected.to contain_file(title).with(content: %r{STORM_NOVOS_ACCESSPOINT='\/novos'})

          is_expected.to contain_file(title).with(content: %r{STORM_STORAGEAREA_LIST='test.vo atlas novos'})
          is_expected.to contain_file(title).with(content: %r{VOS='test.vo test.vo.2 atlas'})
        end

        it 'check if exec of storm-info-provider configure has been run' do
          is_expected.to contain_exec('configure-info-provider')
        end

        it 'check service file content' do
          title = '/etc/systemd/system/storm-backend-server.service.d/storm-backend-server.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{^Environment="STORM_BE_JVM_OPTS=-Xms512m -Xmx1024m"})
          is_expected.to contain_file(title).with(content: %r{^Environment="LCMAPS_DB_FILE=\/etc\/storm\/backend-server\/lcmaps.db"})
          is_expected.to contain_file(title).with(content: %r{^Environment="LCMAPS_POLICY_NAME=standard"})
          is_expected.to contain_file(title).with(content: %r{^Environment="LCMAPS_LOG_FILE=\/var\/log\/storm\/lcmaps.log"})
          is_expected.to contain_file(title).with(content: %r{^Environment="LCMAPS_DEBUG_LEVEL=0"})
        end

        it 'check service file limit content' do
          title = '/etc/systemd/system/storm-backend-server.service.d/filelimit.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{^LimitNOFILE=15535})
        end

        it 'check db scripts exist' do
          storm_db = '/tmp/storm_db.sql'
          is_expected.to contain_file(storm_db).with(
            ensure: 'present',
          )
          storm_be_isam = '/tmp/storm_be_ISAM.sql'
          is_expected.to contain_file(storm_be_isam).with(
            ensure: 'present',
          )
        end

        it 'check storm db creation' do
          is_expected.to contain_exec('storm_db-import')
        end

        it 'check storm be ISAM db creation' do
          is_expected.to contain_exec('storm_be_ISAM-import')
        end

        it 'check path-authz.db file not initialized' do
          is_expected.not_to contain_file('/etc/storm/backend-server/path-authz.db')
        end

        context 'test path authz db' do
          let(:params) do
            {
              'path_authz_db_file' => '/path/to/path-authz.db',
            }
          end

          it 'check path-authz.db file source' do
            is_expected.to contain_file('/etc/storm/backend-server/path-authz.db').with(
              ensure: 'present',
              owner: 'root',
              group: 'storm',
              mode: '0644',
              source: '/path/to/path-authz.db',
            )
          end
        end
      end
    end
  end
end
