require 'spec_helper'

describe 'storm::db::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      let(:params) do
        {
          'root_password' => 'test',
        }
      end
      
      case facts[:operatingsystemmajrelease]
      when '6'
        it 'check mysql repo for centos 6 is installed' do
          is_expected.to contain_yumrepo('repo.mysql.com').with(
            :ensure => 'present',
            :descr => 'repo.mysql.com',
            :baseurl => 'http://repo.mysql.com/yum/mysql-5.6-community/el/6/x86_64/',
            :enabled => 1,
            :gpgcheck => true,
            :gpgkey => 'http://repo.mysql.com/RPM-GPG-KEY-mysql',
          )
        end
      when '6'
        it 'check mysql repo for centos 7 is installed' do
          is_expected.to contain_yumrepo('repo.mysql.com').with(
            :ensure => 'present',
            :descr => 'repo.mysql.com',
            :baseurl => 'http://repo.mysql.com/yum/mysql-5.6-community/el/7/x86_64/',
            :enabled => 1,
            :gpgcheck => true,
            :gpgkey => 'http://repo.mysql.com/RPM-GPG-KEY-mysql',
          )
        end
      end

      it 'check mysql client is installed' do
        is_expected.to contain_class('mysql::client').with(
          :package_name => 'mysql-community-client',
        )
      end

      it 'check mysql server is installed' do
        is_expected.to contain_class('mysql::server').with(
          :package_name => 'mysql-community-server',
          :root_password => 'test',
          :manage_config_file => true,
          :service_name => 'mysqld',
        )
      end

    end
  end
end