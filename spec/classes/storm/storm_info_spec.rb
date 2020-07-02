require 'spec_helper'

describe 'storm::info', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'Check no params' do
      end

      context 'Custom configuration' do
        let(:params) do 
          {
            'sitename' => 'test',
            'backend_hostname' => 'storm-be.example.org',
            'frontend_public_host' => 'storm-fe.example.org',
            'storage_default_root' => '/another-storage',
            'frontend_port' => 8445,
            'rest_services_port' => 9997,
            'endpoint_quality_level' => 1,
            'srm_pool_members' => [
              {
                'hostname' => 'frontend-0.example.com',
              }, {
                'hostname' => 'frontend-1.example.com',
              }
            ],
            'webdav_pool_members' => [
              {
                'hostname' => 'webdav-0.example.com',
              }, {
                'hostname' => 'webdav-1.example.com',
              }
            ],
            'transfer_protocols' => ['file','gsiftp','webdav'],
            'storage_areas'       => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'storage_class' => 'T1D1',
                'online_size' => 4,
                'nearline_size' => 10,
                'transfer_protocols' => ['file','gsiftp','xroot','webdav'],
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'access_points' => ['/atlas', '/atlasdisk'],
                'vos' => ['atlas'],
                'fs_type' => 'gpfs',
                'storage_class' => 'T1D0',
                'online_size' => 4,
                'nearline_size' => 20,
              },
            ],
          }
        end

        it "check info provider configuration file content" do
          title='/etc/storm/info-provider/storm-yaim-variables.conf'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
          )
          is_expected.to contain_file(title).with( :content => /SITE_NAME=test/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PUBLIC_HOST=storm-fe.example.org/ )
          is_expected.to contain_file(title).with( :content => /STORM_BACKEND_HOST=storm-be.example.org/ )
          is_expected.to contain_file(title).with( :content => /STORM_DEFAULT_ROOT=\/another-storage/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PATH=\/srm\/managerv2/ )
          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_PORT=8445/ )
          is_expected.to contain_file(title).with( :content => /STORM_BACKEND_REST_SERVICES_PORT=9997/ )
          is_expected.to contain_file(title).with( :content => /STORM_ENDPOINT_QUALITY_LEVEL=1/ )

          is_expected.to contain_file(title).with( :content => /STORM_INFO_FILE_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_RFIO_SUPPORT=false/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_GRIDFTP_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_ROOT_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_HTTP_SUPPORT=true/ )
          is_expected.to contain_file(title).with( :content => /STORM_INFO_HTTPS_SUPPORT=true/ )

          is_expected.to contain_file(title).with( :content => /STORM_FRONTEND_HOST_LIST=frontend-0.example.com,frontend-1.example.com/ )

          is_expected.to contain_file(title).with( :content => /STORM_WEBDAV_POOL_LIST=http:\/\/webdav-0.example.com:8085\/,https:\/\/webdav-0.example.com:8443\/,http:\/\/webdav-1.example.com:8085\/,https:\/\/webdav-1.example.com:8443\// )

          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_VONAME='test.vo test.vo.2'/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ONLINE_SIZE=4/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_NEARLINE_SIZE=10/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_TOKEN=TESTVO-TOKEN/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ROOT=\/storage\/test.vo/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_STORAGECLASS=T1D1/ )
          is_expected.to contain_file(title).with( :content => /STORM_TESTVO_ACCESSPOINT='\/test.vo'/ )

          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_VONAME='atlas'/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ONLINE_SIZE=4/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_NEARLINE_SIZE=20/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_TOKEN=ATLAS-TOKEN/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ROOT=\/storage\/atlas/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_STORAGECLASS=T1D0/ )
          is_expected.to contain_file(title).with( :content => /STORM_ATLAS_ACCESSPOINT='\/atlas \/atlasdisk'/ )

          is_expected.to contain_file(title).with( :content => /STORM_STORAGEAREA_LIST='test.vo atlas'/ )
          is_expected.to contain_file(title).with( :content => /VOS='test.vo test.vo.2 atlas'/ )
        end

        it "check if exec of storm-info-provider configure has been run" do
          is_expected.to contain_exec('configure-info-provider')
        end
      end

    end
  end
end