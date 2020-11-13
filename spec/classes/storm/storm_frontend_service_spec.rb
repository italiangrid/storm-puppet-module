require 'spec_helper'

describe 'storm::frontend::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) do
        'include storm::frontend::install'
      end

      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it 'service resource exists' do
        is_expected.to contain_service('storm-frontend-server').with(
          ensure: 'running',
          enable: 'true',
        )
      end
    end
  end
end
