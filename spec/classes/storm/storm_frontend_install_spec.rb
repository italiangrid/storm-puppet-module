require 'spec_helper'

describe 'storm::frontend::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm frontend metapackage is installed' do
        is_expected.to contain_package('storm-frontend-server').with(ensure: 'installed')
      end

      it 'check all dependencies are installed' do
        dependencies = [
          'umd-release',
          'fetch-crl',
          'edg-mkgridmap',
          'lcg-expiregridmapdir',
          'cleanup-grid-accounts',
        ]
        dependencies.each do |rpm|
          is_expected.to contain_package(rpm).with(ensure: 'installed')
        end
      end
    end
  end
end