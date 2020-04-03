require 'spec_helper'

describe 'storm::users', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'Test context 1' do
        let(:params) do 
          {
            'storm_uid' => 1100,
            'storm_gid' => 1100,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it "check storm user" do

          is_expected.to contain_accounts__user('storm').with( 
            :ensure     => 'present',
            :uid        => 1100,
            :gid        => 1100,
            :group      => 'storm',
            :groups     => ['storm', 'edguser'],
          )
        end
      end

      context 'Test context 2' do
      end

    end
  end
end