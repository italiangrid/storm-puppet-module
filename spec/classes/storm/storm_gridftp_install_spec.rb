require 'spec_helper'

describe 'storm::gridftp::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm globus gridftp metapackage is installed' do
        is_expected.to contain_package('gftp::install-storm-globus-gridftp-server').with(ensure: 'installed')
      end

    end
  end
end