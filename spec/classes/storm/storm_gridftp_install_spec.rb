require 'spec_helper'

describe 'storm::gridftp::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm globus gridftp metapackage is installed' do
        is_expected.to contain_package('storm-globus-gridftp-mp').with(ensure: 'installed')
      end

    end
  end
end