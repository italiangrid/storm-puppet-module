require 'spec_helper'

describe 'storm::frontend', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }

      context 'Use custom frontend params' do

        let(:params) do 
          {
            'port'                      => 8445,
            'threadpool_threads_number' => 60,
            'gsoap_maxpending'          => 2000,
            'config_dir'                => '/etc/storm/fe/config',
            'user_name'                 => 'test',
            'log_debuglevel'            => 'DEBUG',
            'security_enable_vomscheck' => false,
            'be_xmlrpc_host'            => 'example.com',
            'be_xmlrpc_token'           => 'secret',
            'be_xmlrpc_port'            => 8086,
            'be_xmlrpc_path'            => '/RPC3',
            'be_recalltable_port'       => 9999,
            'db_host'                   => 'example.com',
            'db_user'                   => 'test',
            'db_passwd'                 => 'password',
            'check_user_blacklisting'   => true,
            'argus_pepd_endpoint'       => 'example.com',
            'monitoring_enabled'        => false,
            'monitoring_time_interval'  => 50,
            'monitoring_detailed'       => true,
          }
        end

        it "check storm frontend configuration directory" do
          is_expected.to contain_file('fe::storm-fe-config-dir').with( 
            :owner  => 'test',
            :group  => 'test',
            :mode   => '0750',
            :ensure => 'directory',
            :path   => '/etc/storm/fe/config',
          )
        end

        it "check frontend conf file content" do
          title='fe::configure-fe-conf-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/storm/fe/config/storm-frontend-server.conf',
          )
          is_expected.to contain_file(title).with( :content => /fe.port=8445/ )
          is_expected.to contain_file(title).with( :content => /fe.threadpool.threads.number=60/ )
          is_expected.to contain_file(title).with( :content => /fe.gsoap.maxpending=2000/ )
          is_expected.to contain_file(title).with( :content => /log.debuglevel=DEBUG/ )
          is_expected.to contain_file(title).with( :content => /security.enable.vomscheck=false/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.host=example.com/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.token=secret/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.port=8086/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.path=\/RPC3/ )
          is_expected.to contain_file(title).with( :content => /be.recalltable.port=9999/ )
          is_expected.to contain_file(title).with( :content => /db.host=example.com/ )
          is_expected.to contain_file(title).with( :content => /db.user=test/ )
          is_expected.to contain_file(title).with( :content => /db.passwd=password/ )
          is_expected.to contain_file(title).with( :content => /check.user.blacklisting=true/ )
          is_expected.to contain_file(title).with( :content => /argus-pepd-endpoint=example.com/ )
          is_expected.to contain_file(title).with( :content => /monitoring.enabled=false/ )
          is_expected.to contain_file(title).with( :content => /#monitoring.timeInterval=60/ )
          is_expected.to contain_file(title).with( :content => /#monitoring.detailed=false/ )
        end

        it "check sysconfig file" do
          sysconfig_file='fe::configure-sysconfig-file'
          is_expected.to contain_file(sysconfig_file).with(
            :ensure => 'present',
            :path   => '/etc/sysconfig/storm-frontend-server',  
          )
          is_expected.to contain_file(sysconfig_file).that_notifies(['Service[storm-frontend-server]'])
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_FE_USER=test/ )
        end
      end

      context 'Use default frontend params' do

        it "check storm frontend configuration directory" do
          is_expected.to contain_file('fe::storm-fe-config-dir').with( 
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0750',
            :ensure => 'directory',
            :path   => '/etc/storm/storm-frontend',
          )
        end

        it "check frontend conf file content" do
          title='fe::configure-fe-conf-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/storm/storm-frontend/storm-frontend-server.conf',
          )
          is_expected.to contain_file(title).with( :content => /fe.port=8444/ )
          is_expected.to contain_file(title).with( :content => /fe.threadpool.threads.number=50/ )
          is_expected.to contain_file(title).with( :content => /fe.gsoap.maxpending=1000/ )
          is_expected.to contain_file(title).with( :content => /log.debuglevel=INFO/ )
          is_expected.to contain_file(title).with( :content => /security.enable.vomscheck=true/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.host=localhost/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.token=token/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.port=8080/ )
          is_expected.to contain_file(title).with( :content => /be.xmlrpc.path=\/RPC2/ )
          is_expected.to contain_file(title).with( :content => /be.recalltable.port=9998/ )
          is_expected.to contain_file(title).with( :content => /db.host=localhost/ )
          is_expected.to contain_file(title).with( :content => /db.user=storm/ )
          is_expected.to contain_file(title).with( :content => /db.passwd=secret/ )
          is_expected.to contain_file(title).with( :content => /check.user.blacklisting=false/ )
          is_expected.to contain_file(title).with( :content => /#argus-pepd-endpoint=/ )
          is_expected.to contain_file(title).with( :content => /monitoring.enabled=true/ )
          is_expected.to contain_file(title).with( :content => /monitoring.timeInterval=60/ )
          is_expected.to contain_file(title).with( :content => /monitoring.detailed=false/ )

        end

        it "check sysconfig file" do
          sysconfig_file='fe::configure-sysconfig-file'
          is_expected.to contain_file(sysconfig_file).with(
            :ensure => 'present',
            :path   => '/etc/sysconfig/storm-frontend-server',  
          )
          is_expected.to contain_file(sysconfig_file).that_notifies(['Service[storm-frontend-server]'])
          is_expected.to contain_file(sysconfig_file).with( :content => /STORM_FE_USER=storm/ )
        end
      end

    end
  end
end