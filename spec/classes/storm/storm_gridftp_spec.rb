require 'spec_helper'

describe 'storm::gridftp', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it 'config class is used' do
        is_expected.to contain_class('storm::gridftp::config')
      end

      context 'Use custom gridftp params' do
        let(:params) do
          {
            'port'                  => 2911,
            'port_range'            => '30000,40000',
            'connections_max'       => 4000,
            'redirect_lcmaps_log'   => true,
            'llgt_log_file'         => '/var/log/storm/lcmaps.log',
            'lcmaps_debug_level'    => 0,
            'lcas_debug_level'      => 0,
            'load_storm_dsi_module' => false,
          }
        end

        it 'check gridftp conf file content' do
          title = '/etc/grid-security/gridftp.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{^port 2911})
          is_expected.to contain_file(title).with(content: %r{^port_range 30000,40000})
          is_expected.to contain_file(title).with(content: %r{^connections_max 4000})
          is_expected.to contain_file(title).with(content: %r{^# load_dsi_module StoRM})
          is_expected.to contain_file(title).with(content: %r{^# allowed_modules StoRM})
        end

        it 'check gridftp sysconf file content' do
          title = '/etc/sysconfig/storm-globus-gridftp'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{LLGT_LOG_FILE=\/var\/log\/storm\/lcmaps.log})
          is_expected.to contain_file(title).with(content: %r{LCMAPS_DEBUG_LEVEL=0})
          is_expected.to contain_file(title).with(content: %r{LCAS_DEBUG_LEVEL=0})
        end
      end

      context 'Use default gridftp params' do
        it 'check gridftp conf file content' do
          title = '/etc/grid-security/gridftp.conf'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{port 2811})
          is_expected.to contain_file(title).with(content: %r{port_range 20000,25000})
          is_expected.to contain_file(title).with(content: %r{connections_max 2000})
          is_expected.to contain_file(title).with(content: %r{^load_dsi_module StoRM})
          is_expected.to contain_file(title).with(content: %r{^allowed_modules StoRM})
        end

        it 'check previous gridftp conf file not exists' do
          title = '/etc/gridftp.conf'
          is_expected.to contain_file(title).with(ensure: 'absent')
        end

        it 'check gridftp sysconf file content' do
          title = '/etc/sysconfig/storm-globus-gridftp'
          is_expected.to contain_file(title).with(
            ensure: 'present',
          )
          is_expected.to contain_file(title).with(content: %r{#LLGT_LOG_FILE=\/var\/log\/storm\/storm-gridftp-lcmaps.log})
          is_expected.to contain_file(title).with(content: %r{LCMAPS_DEBUG_LEVEL=3})
          is_expected.to contain_file(title).with(content: %r{LCAS_DEBUG_LEVEL=3})
        end
      end
    end
  end
end
