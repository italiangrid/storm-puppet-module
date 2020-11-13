require 'spec_helper'

describe 'storm::backend::service_conf_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        <<-EOF
          class { 'storm::backend':
            hostname => 'storm.example.org',
          }
        EOF
      end

      let(:facts) do
        facts
      end

      let(:title) { 'override.conf' }

      let(:params) do
        {
          'source' => '/path/to/ovveride.conf',
        }
      end

      it 'check override file exists' do
        override_file = '/etc/systemd/system/storm-backend-server.service.d/override.conf'
        is_expected.to contain_file(override_file).with(
          source: '/path/to/ovveride.conf',
        )
      end
    end
  end
end
