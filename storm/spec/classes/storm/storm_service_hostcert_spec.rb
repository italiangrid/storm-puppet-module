require 'spec_helper'

describe 'storm::service_hostcert' do
  
    context 'sanity check' do

        let(:params) do 
            {
                :hostcert => '/path/to/hostcert.pem',
                :hostkey => '/path/to/hostkey.pem',
                :owner => 'test_user',
                :group => 'test_group',
            }
        end

        it { is_expected.to compile.with_all_deps }

        it "check hostcert.pem" do
            is_expected.to contain_file('/path/to/hostcert.pem').with( 
                :ensure => 'present',
                :owner  => 'test_user',
                :group  => 'test_group',
                :mode   => '0644',
            )
        end

        it "check hostkey.pem" do
            is_expected.to contain_file('/path/to/hostkey.pem').with( 
                :ensure => 'present',
                :owner  => 'test_user',
                :group  => 'test_group',
                :mode   => '0400',
            )
        end

    end
end