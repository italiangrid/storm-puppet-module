require 'spec_helper'

describe 'storm::frontend::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it 'check storm frontend metapackage is installed' do
        is_expected.to contain_package('storm-frontend-server').with(ensure: '>=1.8.16')
      end
    end
  end
end
