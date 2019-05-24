require 'spec_helper'

describe 'storm::webdav::install' do

    let(:facts) { { :osfamily => 'RedHat' } }

    it { is_expected.to compile }

    it { is_expected.to contain_package('storm-webdav').with(ensure: 'present') }

end