require 'spec_helper'

describe 'storm::webdav' do

  let(:facts) { { :osfamily => 'RedHat' } }

  it { is_expected.to compile }

end