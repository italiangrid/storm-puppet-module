require 'spec_helper'

describe 'storm_webdav::params' do

    context 'no RedHat os family' do
    
        let(:facts) { { :osfamily => 'Debian' } }
        it { is_expected.to raise_error }
      end
    
    context 'RedHat os family' do

        let(:facts) { { :osfamily => 'RedHat' } }
        it { is_expected.to compile.with_all_deps }

    end
end