require 'spec_helper'

describe 'storm::backend', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:params) do 
        {
          'hostname' => 'storm.example',
        }
      end

      let(:facts) do
        facts
      end

      # it { is_expected.to compile }
      # it { is_expected.to compile.with_all_deps }

      context 'Use custom backend params' do

        let(:params) do
          super().merge({
            'hostname' => 'storm.example.org',
            'frontend_public_host' => 'frontend.example.org',
            'db_storm_username' => 'test',
            'db_storm_password' => 'secret',
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
            'storage_areas'       => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'storage_class' => 'T1D1',
                'online_size' => 4,
                'nearline_size' => 10,
                'transfer_protocols' => ['file','gsiftp','root','http','https'],
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
                'transfer_protocols' => ['file','gsiftp'],
                'gsiftp_pool_balance_strategy' => 'weight',
                'gsiftp_pool_members' => [
                  {
                    'hostname' => 'gridftp-0.example.org',
                    'weight' => 50,
                  }, {
                    'hostname' => 'gridftp-1.example.org',
                  }
                ],
              },
            ],
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

          # is_expected.to contain_file(title).with( :content => // )
          # is_expected.to contain_file(title).with( :content => // )
          # is_expected.to contain_file(title).with( :content => // )
          # is_expected.to contain_file(title).with( :content => // )
        end

      end

      context 'Use default backend params' do

      end

    end
  end
end