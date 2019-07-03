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

        it { is_expected.to contain_file('/storage').with( 
          :owner => 'storm',
          :group => 'storm',
          :ensure => 'directory'
        )}
    
        it { is_expected.to contain_user('storm').with(
          :ensure => 'present'
        )}

        it { is_expected.to contain_file('/etc/storm').with( 
          :owner => 'root',
          :group => 'storm',
          :ensure => 'directory',
          :mode => '0750',
        )}

        it { is_expected.to contain_file('/var/log/storm').with( 
          :owner => 'storm',
          :group => 'storm',
          :ensure => 'directory',
          :mode => '0755',
        )}
      end
    
      context 'with custom values for parameters' do
    
        let(:params) do 
          {
            :user_name => 'test',
            :storage_root_dir => '/another_storage',
            :config_dir => '/etc/storm_alternative'
          }
        end
    
        it { is_expected.to contain_file('/another_storage').with( 
          :owner => 'test',
          :group => 'test',
          :ensure => 'directory'
        )}
    
        it { is_expected.to contain_user('test').with(
          :ensure => 'present'
        )}

        it { is_expected.to contain_file('/etc/storm_alternative').with( 
          :owner => 'root',
          :group => 'test',
          :ensure => 'directory',
          :mode => '0750',
        )}
      end
    end
  end

end
