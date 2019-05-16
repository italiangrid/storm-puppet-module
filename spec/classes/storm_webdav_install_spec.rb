require 'spec_helper'

describe 'storm_webdav::install' do

    it { is_expected.to contain_package('storm-webdav').with(ensure: 'present') }

end