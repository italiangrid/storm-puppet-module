require 'spec_helper'

describe 'storm::webdav::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'When username is set' do

        let(:params) do 
          {
            'user_name' => 'test',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('dav::install-storm-webdav-rpm').with(ensure: 'installed') }

        it "check storm-webdav service user" do
          is_expected.to contain_storm__user('dav::storm-user')
          is_expected.to contain_user('test').with( 
            :ensure => 'present',
            :uid => 1100,
            :gid => 'test',
          )
          is_expected.to contain_group('test').with( 
              :ensure => 'present',
              :gid => 1100,
            )
        end
      end

      context 'When username and uid are set' do

        let(:params) do 
          {
            'user_name' => 'test',
            'user_uid' => 1300,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('dav::install-storm-webdav-rpm').with(ensure: 'installed') }

        it "check storm-webdav service user" do
          is_expected.to contain_storm__user('dav::storm-user')
          is_expected.to contain_user('test').with( 
            :ensure => 'present',
            :uid => 1300,
            :gid => 'test',
          )
          is_expected.to contain_group('test').with( 
              :ensure => 'present',
              :gid => 1100,
            )
        end
      end

      context 'When username, uid and gid are set' do

        let(:params) do 
          {
            'user_name' => 'test',
            'user_uid' => 1300,
            'user_gid' => 1400,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('dav::install-storm-webdav-rpm').with(ensure: 'installed') }

        it "check storm-webdav service user" do
          is_expected.to contain_storm__user('dav::storm-user')
          is_expected.to contain_user('test').with( 
            :ensure => 'present',
            :uid => 1300,
            :gid => 'test',
          )
          is_expected.to contain_group('test').with( 
              :ensure => 'present',
              :gid => 1400,
            )
        end
      end

    end
  end

end