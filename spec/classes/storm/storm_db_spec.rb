require 'spec_helper'

describe 'storm::db', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      context 'Custom configuration' do
        let(:params) do 
          {
            'fqdn_hostname' => 'test.example.org',
            'root_password' => 'password',
            'storm_username' => 'test',
            'storm_password' => 'secret',
          }
        end

        it "check db scripts exist" do
          storm_db='/tmp/storm_db.sql'
          is_expected.to contain_file(storm_db).with( 
            :ensure => 'present',
          )
          storm_be_isam='/tmp/storm_be_ISAM.sql'
          is_expected.to contain_file(storm_be_isam).with( 
            :ensure => 'present',
          )
        end

        it "check storm db creation" do
          is_expected.to contain_mysql__db('storm_db').with(
            :user => 'test',
            :password => 'secret',
            :host => 'test.example.org',
            :grant => 'ALL',
            :sql => '/tmp/storm_db.sql',
          )
        end

        it "check storm be ISAM db creation" do
          is_expected.to contain_mysql__db('storm_be_ISAM').with(
            :user => 'test',
            :password => 'secret',
            :host => 'test.example.org',
            :grant => 'ALL',
            :sql => '/tmp/storm_be_ISAM.sql',
          )
        end
      end

    end
  end
end