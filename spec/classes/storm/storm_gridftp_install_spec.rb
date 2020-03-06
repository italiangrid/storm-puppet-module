require 'spec_helper'

describe 'storm::gridftp::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm globus gridftp server is installed' do
        is_expected.to contain_package('storm-globus-gridftp-server').with(ensure: 'installed')
      end

      it 'check all dependencies are installed' do
        dependencies = [
          'umd-release',
          'fetch-crl',
          'edg-mkgridmap',
          'lcas',
          'lcas-plugins-basic',
          'lcas-plugins-voms',
          'lcmaps',
          'lcmaps-plugins-basic',
          'lcmaps-without-gsi',
          'lcmaps-plugins-voms',
          'lcas-lcmaps-gt4-interface',
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