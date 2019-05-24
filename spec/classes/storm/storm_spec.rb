require 'spec_helper'

describe 'storm' do

  let(:facts) { { :osfamily => 'RedHat' } }

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('storm::install') }
  it { is_expected.to contain_class('storm::config') }

end
