require 'spec_helper'

describe 'storm::service_hostcert', :type => 'define' do
  
    context 'sanity check' do

        let(:title) { 'storm::service_hostcert' }
        let(:params) do 
            {
                :hostcert => '/path/to/hostcert.pem',
                :hostkey => '/path/to/hostkey.pem',
                :owner => 'test_user',
                :group => 'test_group',
            }
        end

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