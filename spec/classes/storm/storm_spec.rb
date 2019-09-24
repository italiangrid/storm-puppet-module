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

      #  it "check storm configuration directory" do
      #    is_expected.to contain_file('/etc/storm').with( 
      #      :owner => 'root',
      #      :group => 'storm',
      #      :ensure => 'directory',
      #      :mode => '0750',
      #    )
      #  end
      end
    
      context 'with custom values for parameters' do
    
      #  let(:params) do 
      #    {
      #      'config_dir' => '/etc/another/storm',
      #    }
      #  end

      #  it "check storm configuration directory" do
      #    is_expected.to contain_file('/etc/another/storm').with( 
      #      :owner => 'root',
      #      :group => 'test',
      #      :ensure => 'directory',
      #      :mode => '0750',
      #    )
      #  end

      end
    end
  end

end
