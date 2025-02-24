require 'spec_helper'

describe 'storm::webdav::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        <<-EOF
          class { 'storm::webdav':
            scitags_enabled => false,
          }
        EOF
      end

      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_service('storm-webdav').with(ensure: 'running') }
    end
  end
end
