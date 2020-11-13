require 'spec_helper'

describe 'storm::webdav::storage_area_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        <<-EOF
          class { 'storm::webdav':
            hostnames => ['storm.webdav.org'],
          }
        EOF
      end

      let(:facts) do
        facts
      end

      let(:title) { 'test.vo.properties' }

      let(:params) do
        {
          'source' => '/path/to/test.vo.properties',
        }
      end

      it 'check storage area file exists' do
        storage_area_file = '/etc/storm/webdav/sa.d/test.vo.properties'
        is_expected.to contain_file(storage_area_file).with(
          source: '/path/to/test.vo.properties',
        )
      end
    end
  end
end
