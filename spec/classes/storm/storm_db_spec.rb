require 'spec_helper'

describe 'storm::db', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:params) do
        {
          'fqdn_hostname' => 'storm.example.org',
          'storm_password' => 'password',
          'root_password' => 'password',
        }
      end

      let(:facts) do
        facts
      end

      context 'with custom db params' do
        it 'check mysql client is installed' do
          is_expected.to contain_class('mysql::client')
        end

        it 'check mysql server is installed' do
          is_expected.to contain_class('mysql::server').with(
            manage_config_file: true,
            root_password: 'password',
            restart: true,
            override_options: {
              'mysqld' => {
                'bind-address'    => '0.0.0.0',
                'max_connections' => 2048,
                'wait_timeout'    => 86_400,
              },
            },
            databases: {
              'storm_db' => {
                'ensure'  => 'present',
                'charset' => 'utf8',
                'collate' => 'utf8_general_ci',
              },
              'storm_be_ISAM' => {
                'ensure'  => 'present',
                'charset' => 'utf8',
                'collate' => 'utf8_general_ci',
              },
            },
          )
        end

        service_dir = '/etc/systemd/system/mariadb.service.d'
        service_file = '/etc/systemd/system/mariadb.service.d/limits.conf'
        it 'check mysql service dir and override file exist' do
          is_expected.to contain_file(service_dir).with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0644',
          )
          is_expected.to contain_file(service_file).with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0644',
          )
        end

        it 'check grants on storm_db' do
          is_expected.to contain_mysql_grant('storm@storm.example.org/storm_db.*').with(
            privileges: 'ALL',
            user: 'storm@storm.example.org',
            table: 'storm_db.*',
          )
          is_expected.to contain_mysql_grant('storm@storm/storm_db.*').with(
            privileges: 'ALL',
            user: 'storm@storm',
            table: 'storm_db.*',
          )
          is_expected.to contain_mysql_grant('storm@localhost/storm_db.*').with(
            privileges: 'ALL',
            user: 'storm@localhost',
            table: 'storm_db.*',
          )
          is_expected.to contain_mysql_grant('storm@%/storm_db.*').with(
            privileges: 'ALL',
            user: 'storm@%',
            table: 'storm_db.*',
          )
        end

        it 'check grants on storm_be_ISAM' do
          is_expected.to contain_mysql_grant('storm@storm.example.org/storm_be_ISAM.*').with(
            privileges: 'ALL',
            user: 'storm@storm.example.org',
            table: 'storm_be_ISAM.*',
          )
          is_expected.to contain_mysql_grant('storm@storm/storm_be_ISAM.*').with(
            privileges: 'ALL',
            user: 'storm@storm',
            table: 'storm_be_ISAM.*',
          )
          is_expected.to contain_mysql_grant('storm@localhost/storm_be_ISAM.*').with(
            privileges: 'ALL',
            user: 'storm@localhost',
            table: 'storm_be_ISAM.*',
          )
          is_expected.to contain_mysql_grant('storm@%/storm_be_ISAM.*').with(
            privileges: 'ALL',
            user: 'storm@%',
            table: 'storm_be_ISAM.*',
          )
        end

        it 'check users' do
          is_expected.to contain_mysql_user('storm@storm.example.org')
          is_expected.to contain_mysql_user('storm@storm')
          is_expected.to contain_mysql_user('storm@localhost')
          is_expected.to contain_mysql_user('storm@%')
        end

        it 'check exec reload' do
          is_expected.to contain_exec('mariadb-daemon-reload')
        end
      end
    end
  end
end
