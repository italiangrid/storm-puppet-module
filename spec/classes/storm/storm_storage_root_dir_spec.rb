require 'spec_helper'

describe 'storm::storage_root_dir', :type => 'define' do
  
    context 'sanity check' do

        let(:title) { 'test_check_dir' }
        let(:params) do 
            {
                :path => '/tmp/testdir',
                :owner => 'test_user',
                :group => 'test_group',
            }
        end

        it "check all exec are executed when dir not exists" do
            is_expected.to contain_exec('test_check_dir_create_root_directory')
            is_expected.to contain_exec('test_check_dir_set_ownership_on_root_directory')
            is_expected.to contain_exec('test_check_dir_set_permissions_on_root_directory')
        end

    end
end