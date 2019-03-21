require 'spec_helper'

describe 'storm' do

  let(:params) { { :storm_user_name => 'storm' } }  
  let(:params) { { :storm_storage_root_directory => '/storage' } }


  it { is_expected.to contain_file('/storage')
    .with(
      :ensure => 'directory',
    )
  }

end

