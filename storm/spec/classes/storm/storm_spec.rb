require 'spec_helper'

describe 'storm', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('storm::install') }
      it { is_expected.to contain_class('storm::config') }
    
      context 'with default values for parameters' do
    
        it "check storm user" do
          is_expected.to contain_storm__user('storm user')
          is_expected.to contain_user('storm').with( 
            :ensure => 'present',
            :uid => 1000,
            :gid => 1000
          )
        end

        it "check storage root directory" do
          is_expected.to contain_storm__storage_root_dir('check_storage_root_dir')
          is_expected.to contain_exec('check_storage_root_dir_create_root_directory')
          is_expected.to contain_exec('check_storage_root_dir_set_ownership_on_root_directory')
          is_expected.to contain_exec('check_storage_root_dir_set_permissions_on_root_directory')
        end

        it "check storm configuration directory" do
          is_expected.to contain_file('/etc/storm').with( 
            :owner => 'root',
            :group => 'storm',
            :ensure => 'directory',
            :mode => '0750',
          )
        end

        it "check storm log directory" do
          is_expected.to contain_file('/var/log/storm').with( 
            :owner => 'storm',
            :group => 'storm',
            :ensure => 'directory',
            :mode => '0755',
          )
        end
      end
    
      context 'with custom values for parameters' do
    
        let(:params) do 
          {
            'user_name' => 'test',
            'user_uid' => 1200,
            'user_gid' => 1300,
            'storage_root_dir' => '/another/storage',
            'config_dir' => '/etc/another/storm',
            'log_dir' => '/var/another/log',
          }
        end
    
        it "check storage root directory" do
          is_expected.to contain_storm__storage_root_dir('check_storage_root_dir')
          is_expected.to contain_exec('check_storage_root_dir_create_root_directory')
          is_expected.to contain_exec('check_storage_root_dir_set_ownership_on_root_directory')
          is_expected.to contain_exec('check_storage_root_dir_set_permissions_on_root_directory')
        end

        it "check storm user" do
          is_expected.to contain_storm__user('storm user')
          is_expected.to contain_user('test').with( 
            :ensure => 'present',
            :uid => 1200,
            :gid => 1300
          )
        end

        it "check storm configuration directory" do
          is_expected.to contain_file('/etc/another/storm').with( 
            :owner => 'root',
            :group => 'test',
            :ensure => 'directory',
            :mode => '0750',
          )
        end

        it "check storm log directory" do
          is_expected.to contain_file('/var/another/log').with( 
            :owner => 'test',
            :group => 'test',
            :ensure => 'directory',
            :mode => '0755',
          )
        end

      end
    end
  end

end
