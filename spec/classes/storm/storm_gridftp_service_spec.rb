require 'spec_helper'

describe 'storm::gridftp::service' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_service('storm-globus-gridftp').with(ensure: 'running') }

    end
  end

end