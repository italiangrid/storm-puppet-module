require 'spec_helper'

describe 'storm', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('storm::install') }
      it { is_expected.to contain_class('storm::config') }

    end
  end

end
