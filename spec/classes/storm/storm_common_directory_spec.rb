require 'spec_helper'

describe 'storm::common_directory', :type => 'define' do
  
    context 'sanity check' do

        let(:title) { 'TEST' }
        let(:params) do 
            {
                :path => '/tmp/testdir',
                :owner => 'test_user',
                :group => 'test_group',
            }
        end

        it "check all exec are executed when dir not exists" do
            is_expected.to contain_exec("mkdir_TEST")
            is_expected.to contain_exec('chown_TEST')
            is_expected.to contain_exec('chmod_TEST')
        end

    end
end