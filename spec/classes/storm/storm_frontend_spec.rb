require 'spec_helper'

describe 'storm::frontend', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          'be_xmlrpc_host' => 'storm.example.org',
        }
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }

      it 'config class is used' do
        is_expected.to contain_class('storm::frontend::config')
      end

      context 'Check frontend host credentials' do
        it 'Check /etc/grid-security/storm directory' do
          is_expected.to contain_file('/etc/grid-security/storm').with(
            ensure: 'directory',
            owner: 'storm',
            group: 'storm',
            mode: '0755',
          )
          is_expected.to contain_file('/etc/grid-security/storm/hostcert.pem').with(
            ensure: 'present',
            owner: 'storm',
            group: 'storm',
            mode: '0644',
          )
          is_expected.to contain_file('/etc/grid-security/storm/hostkey.pem').with(
            ensure: 'present',
            owner: 'storm',
            group: 'storm',
            mode: '0400',
          )
        end
      end

      context 'Use your own frontend configuration file' do
        let(:params) do
          super().merge(
            'configuration_file' => '/path/to/your/storm-frontend-server.conf',
          )
        end

        it 'check frontend conf file content' do
          title = '/etc/storm/frontend-server/storm-frontend-server.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
            source: '/path/to/your/storm-frontend-server.conf',
          )
        end
      end

      context 'Use custom frontend params' do
        let(:params) do
          super().merge(
            'port'                      => 8445,
            'threadpool_maxpending'     => 300,
            'threadpool_threads_number' => 60,
            'gsoap_maxpending'          => 2000,
            'log_debuglevel'            => 'DEBUG',
            'security_enable_vomscheck' => false,
            'be_xmlrpc_host'            => 'storm.example.org',
            'be_xmlrpc_token'           => 'token',
            'be_xmlrpc_port'            => 8086,
            'be_xmlrpc_path'            => '/RPC3',
            'be_recalltable_port'       => 9999,
            'db_host'                   => 'storm.example.org',
            'db_user'                   => 'test',
            'db_passwd'                 => 'password',
            'check_user_blacklisting'   => true,
            'argus_pepd_endpoint'       => 'storm.example.org',
            'monitoring_enabled'        => false,
            'monitoring_time_interval'  => 50,
            'monitoring_detailed'       => true,
          )
        end

        it 'check frontend conf file content' do
          title = '/etc/storm/frontend-server/storm-frontend-server.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{fe.port=8445})
          is_expected.to contain_file(title).with(content: %r{fe.threadpool.maxpending=300})
          is_expected.to contain_file(title).with(content: %r{fe.threadpool.threads.number=60})
          is_expected.to contain_file(title).with(content: %r{fe.gsoap.maxpending=2000})
          is_expected.to contain_file(title).with(content: %r{log.debuglevel=DEBUG})
          is_expected.to contain_file(title).with(content: %r{security.enable.mapping=false})
          is_expected.to contain_file(title).with(content: %r{security.enable.vomscheck=false})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.host=storm.example.org})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.token=token})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.port=8086})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.path=\/RPC3})
          is_expected.to contain_file(title).with(content: %r{be.recalltable.port=9999})
          is_expected.to contain_file(title).with(content: %r{db.host=storm.example.org})
          is_expected.to contain_file(title).with(content: %r{db.user=test})
          is_expected.to contain_file(title).with(content: %r{db.passwd=password})
          is_expected.to contain_file(title).with(content: %r{check.user.blacklisting=true})
          is_expected.to contain_file(title).with(content: %r{argus-pepd-endpoint=storm.example.org})
          is_expected.to contain_file(title).with(content: %r{monitoring.enabled=false})
          is_expected.to contain_file(title).with(content: %r{#monitoring.timeInterval=60})
          is_expected.to contain_file(title).with(content: %r{#monitoring.detailed=false})
        end

        it 'check sysconfig file' do
          sysconfig_file = '/etc/sysconfig/storm-frontend-server'
          is_expected.to contain_file(sysconfig_file).with(
            ensure: 'present',
          )
          is_expected.to contain_file(sysconfig_file).that_notifies(['Service[storm-frontend-server]'])
          is_expected.to contain_file(sysconfig_file).with(content: %r{STORM_FE_USER=storm})
        end
      end

      context 'Use default frontend params' do
        it 'check frontend conf file content' do
          title = '/etc/storm/frontend-server/storm-frontend-server.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{fe.port=8444})
          is_expected.to contain_file(title).with(content: %r{fe.threadpool.maxpending=200})
          is_expected.to contain_file(title).with(content: %r{fe.threadpool.threads.number=50})
          is_expected.to contain_file(title).with(content: %r{fe.gsoap.maxpending=1000})
          is_expected.to contain_file(title).with(content: %r{log.debuglevel=INFO})
          is_expected.to contain_file(title).with(content: %r{security.enable.mapping=false})
          is_expected.to contain_file(title).with(content: %r{security.enable.vomscheck=true})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.host=storm.example.org})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.token=secret})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.port=8080})
          is_expected.to contain_file(title).with(content: %r{be.xmlrpc.path=\/RPC2})
          is_expected.to contain_file(title).with(content: %r{be.recalltable.port=9998})
          is_expected.to contain_file(title).with(content: %r{db.host=storm.example.org})
          is_expected.to contain_file(title).with(content: %r{db.user=storm})
          is_expected.to contain_file(title).with(content: %r{db.passwd=storm})
          is_expected.to contain_file(title).with(content: %r{check.user.blacklisting=false})
          is_expected.to contain_file(title).with(content: %r{#argus-pepd-endpoint=})
          is_expected.to contain_file(title).with(content: %r{monitoring.enabled=true})
          is_expected.to contain_file(title).with(content: %r{monitoring.timeInterval=60})
          is_expected.to contain_file(title).with(content: %r{monitoring.detailed=false})
        end

        it 'check sysconfig file' do
          sysconfig_file = '/etc/sysconfig/storm-frontend-server'
          is_expected.to contain_file(sysconfig_file).with(
            ensure: 'present',
          )
          is_expected.to contain_file(sysconfig_file).that_notifies(['Service[storm-frontend-server]'])
          is_expected.to contain_file(sysconfig_file).with(content: %r{STORM_FE_USER=storm})
        end
      end
    end
  end
end
