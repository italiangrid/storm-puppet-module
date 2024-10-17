require 'spec_helper'

describe 'storm::webdav::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        <<-EOF
          class { 'storm::webdav':
            scitag_enabled => false,
          }
        EOF
      end
      let(:facts) do
        facts
      end

      it 'check storm webdav rpm is installed' do
        is_expected.to contain_package('storm-webdav')
      end
    end
  end
end
