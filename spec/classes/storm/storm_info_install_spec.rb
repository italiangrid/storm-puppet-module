require 'spec_helper'

describe 'storm::info::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm info provider is installed' do
        is_expected.to contain_package('storm-dynamic-info-provider').with(ensure: 'installed')
      end

    end
  end
end