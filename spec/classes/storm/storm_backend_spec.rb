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

        it "check backend namespace file content" do
          title='/etc/storm/backend-server/namespace.xml'
          is_expected.to contain_file(title).with( 
            :ensure  => 'present',
            :content => my_fixture_read("namespace-0.xml"),
          )
        end

      end

      context 'Use default backend params' do

        it "check storm backend configuration directory" do
          is_expected.to contain_file('/etc/storm/backend-server').with( 
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0750',
            :ensure => 'directory',
          )
        end
      end

    end
  end
end