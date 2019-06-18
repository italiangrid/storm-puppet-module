require 'spec_helper'

describe 'storm::webdav' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'Define some test storage areas' do

        let(:params) do 
          {
            'user_name' => 'test',
            'storage_area' => [
              {
                'name' => 'test.vo',
                'root_path' => '/storage/test.vo',
                'filesystem_type' => 'posixfs',
                'access_points' => ['/test.vo'],
                'vos' => ['test.vo', 'test.vo.2'],
                'orgs' => '',
                'authenticated_read_enabled' => false,
                'anonymous_read_enabled' => false,
              },
              {
                'name' => 'atlas',
                'root_path' => '/storage/atlas',
                'filesystem_type' => 'gpfs',
                'access_points' => ['/atlas', '/atlasdisk'],
                'vos' => ['atlas'],
                'orgs' => '',
                'authenticated_read_enabled' => false,
                'anonymous_read_enabled' => false,
              },
            ]
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('storm-webdav').with(ensure: 'installed') }
        it { is_expected.to contain_service('storm-webdav').with(ensure: 'running') }
  
        it "check storm webdav configuration directory" do
          is_expected.to contain_file('/etc/storm/webdav').with( 
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
          is_expected.to contain_file('/etc/storm/webdav/sa.d/test.vo.properties').with(
            :ensure => 'present'
          )
          is_expected.to contain_file('/etc/storm/webdav/sa.d/atlas.properties').with(
            :ensure => 'present'
          )
        end

      end

      context 'hostcert sanity check' do

        let(:params) do 
          {
            'user_name' => 'test',
          }
        end

        it { is_expected.to compile.with_all_deps }

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

      end
    end
  end

end