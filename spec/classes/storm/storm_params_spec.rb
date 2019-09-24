require 'spec_helper'

describe 'storm::params' do

  context 'no RedHat os family' do
    
    let(:facts) do
      {
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
      }
    end
    it { is_expected.to compile.and_raise_error(/StoRM module not supported on Debian\/Ubuntu./) }

  end

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

    end
  end

end