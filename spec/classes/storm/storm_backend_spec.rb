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

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }

      context 'Use custom backend params' do

        let(:params) do
          super().merge({
            'config_dir'          => '/etc/storm/be/config',
            'user_name'           => 'test',
            'gsiftp_pool_members' => [
              {
                'hostname' => 'gridftp-0.example.com',
              }, {
                'hostname' => 'gridftp-1.example.com',
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
                'storage_class' => 'T0D1',
                'online_size' => 4,
                'nearline_size' => 10,
                'gsiftp_pool_balance_strategy' => 'weight',
                'gsiftp_pool_members' => [
                  {
                    'hostname' => 'gridftp-0.example.com',
                    'weight' => 50,
                  }, {
                    'hostname' => 'gridftp-1.example.com',
                  }
                ],
              },
            ],
          })
        end

        it "check storm backend configuration directory" do
          is_expected.to contain_file('be::storm-be-config-dir').with( 
            :owner  => 'test',
            :group  => 'test',
            :mode   => '0750',
            :ensure => 'directory',
            :path   => '/etc/storm/be/config',
          )
        end

        it "check backend namespace file content" do
          title='be::configure-be-namespace-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/storm/be/config/namespace.xml',
          )
          is_expected.to contain_file(title).with( :content => /<filesystem name="TESTVO-FS" fs_type="ext3">/ )
          is_expected.to contain_file(title).with( :content => /<space-token-description>TESTVO-TOKEN<\/space-token-description>/ )
          is_expected.to contain_file(title).with( :content => /<root>\/storage\/test.vo<\/root>/ )
          is_expected.to contain_file(title).with( :content => /<filesystem-driver>it.grid.storm.filesystem.swig.posixfs<\/filesystem-driver>/ )
          is_expected.to contain_file(title).with( :content => /<spacesystem-driver>it.grid.storm.filesystem.MockSpaceSystem<\/spacesystem-driver>/ )
          is_expected.to contain_file(title).with( :content => /<fixed>permit-all<\/fixed>/ )
          is_expected.to contain_file(title).with( :content => /<RetentionPolicy>custodial<\/RetentionPolicy>/ )
          is_expected.to contain_file(title).with( :content => /<AccessLatency>nearline<\/AccessLatency>/ )
          is_expected.to contain_file(title).with( :content => /<TotalOnlineSize unit="Byte" limited-size="true">4000000000<\/TotalOnlineSize>/ )
          is_expected.to contain_file(title).with( :content => /<TotalNearlineSize unit="Byte">0<\/TotalNearlineSize>/ )
          is_expected.to contain_file(title).with( :content => /<aclMode>AoT<\/aclMode>/ )
          is_expected.to contain_file(title).with( :content => /<prot name="file">/ )
          is_expected.to contain_file(title).with( :content => /<prot name="gsiftp">/ )

        end

      end

      context 'Use default backend params' do

        it "check storm backend configuration directory" do
          is_expected.to contain_file('be::storm-be-config-dir').with( 
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0750',
            :ensure => 'directory',
            :path   => '/etc/storm/backend-server',
          )
        end
      end

    end
  end
end