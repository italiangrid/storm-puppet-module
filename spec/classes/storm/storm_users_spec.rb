require 'spec_helper'

describe 'storm::users', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'Check default storm and edguser user' do

        it { is_expected.to compile.with_all_deps }

        it "check storm user" do

          is_expected.to contain_accounts__user('storm').with( 
            :ensure => 'present',
            :uid    => 991,
            :gid    => 991,
            :group  => 'storm',
            :home   => '/home/storm',
            :groups => ['storm', 'edguser'],
          )
        end

        it "check edguser user" do

          is_expected.to contain_accounts__user('edguser').with( 
            :ensure => 'present',
            :uid    => 995,
            :gid    => 995,
            :group  => 'edguser',
            :home   => '/var/local/edguser',
          )
        end
      end

      context 'Test custom storm user' do
        let(:params) do 
          {
            'storm_uid'    => 1100,
            'storm_gid'    => 1100,
            'storm_groups' => ['storm', 'edguser', 'pippo'],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it "check storm user" do

          is_expected.to contain_accounts__user('storm').with( 
            :ensure     => 'present',
            :uid        => 1100,
            :gid        => 1100,
            :group      => 'storm',
            :groups     => ['storm', 'edguser', 'pippo'],
          )
        end
      end

      context 'Test custom edguser user' do
        let(:params) do 
          {
            'edguser_uid' => 1100,
            'edguser_gid' => 1100,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it "check edguser user" do

          is_expected.to contain_accounts__user('edguser').with( 
            :ensure     => 'present',
            :uid        => 1100,
            :gid        => 1100,
            :group      => 'edguser',
          )
        end
      end

    end
  end
end