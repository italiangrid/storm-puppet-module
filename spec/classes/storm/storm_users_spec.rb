require 'spec_helper'

describe 'storm::users', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'with default storm::users' do

        it "check storm user" do

          is_expected.to contain_accounts__user('storm').with(
            :ensure => 'present',
            :uid    => 1100,
            :gid    => 1100,
            :group  => 'storm',
            :home   => '/home/storm',
            :groups => ['storm', 'edguser'],
          )
        end

        it "check edguser user" do

          is_expected.to contain_accounts__user('edguser').with(
            :ensure => 'present',
            :uid    => 1101,
            :gid    => 1101,
            :group  => 'edguser',
            :home   => '/home/edguser',
            :groups => ['edguser', 'storm'],
          )
        end

      end

      context 'with custom storm::users' do
        let(:params) do 
          {
            'users'    => {
              'edguser' => {
                'comment' => 'Edguser user',
                'groups'  => [ 'edguser', 'storm', ],
                'uid'     => '1101',
                'gid'     => '1101',
              },
              'storm'   => {
                'comment' => 'StoRM user',
                'groups'  => [ 'storm', 'edguser', 'storm-SA-read', 'storm-SA-write' ],
                'uid'     => '1100',
                'gid'     => '1100',
              },
            },
            'groups'   => {
              'storm-SA-read'  => {
                'gid' => '990',
              },
              'storm-SA-write' => {
                'gid' => '989',
              },
            },
          }
        end

        it "check storm-SA-read group" do
          is_expected.to contain_group('storm-SA-read').with(
            :gid        => 990,
          )
        end

        it "check storm-SA-write group" do
          is_expected.to contain_group('storm-SA-write').with(
            :gid        => 989,
          )
        end

        it "check storm user" do

          is_expected.to contain_accounts__user('storm').with(
            :ensure     => 'present',
            :uid        => 1100,
            :gid        => 1100,
            :group      => 'storm',
            :groups     => [ 'storm', 'edguser', 'storm-SA-read', 'storm-SA-write' ],
          )
        end

        it "check edguser user" do

          is_expected.to contain_accounts__user('edguser').with(
            :ensure     => 'present',
            :uid        => 1101,
            :gid        => 1101,
            :group      => 'edguser',
            :groups     => [ 'edguser', 'storm', ],
          )
        end
      end

    end
  end
end