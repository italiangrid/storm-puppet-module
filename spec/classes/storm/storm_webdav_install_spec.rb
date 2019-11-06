require 'spec_helper'

describe 'storm::webdav::install' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it 'check storm webdav rpm is installed' do
        is_expected.to contain_package('storm-webdav').with(ensure: 'installed')
      end
    end
  end

end