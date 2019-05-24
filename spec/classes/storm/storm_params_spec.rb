require 'spec_helper'

describe 'storm::params' do

    context 'no RedHat os family' do
    
        let(:facts) { { :osfamily => 'Debian' } }
        it { is_expected.to compile.and_raise_error(/StoRM module is supported only on RedHat based system./) }
    
    end
    
    context 'RedHat os family' do

        let(:facts) { { :osfamily => 'RedHat' } }
        it { is_expected.to compile.with_all_deps }

    end
end