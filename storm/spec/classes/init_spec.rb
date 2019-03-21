require 'spec_helper'
describe 'storm' do
  context 'with default values for all parameters' do
    it { should contain_class('storm') }
  end

  let(:params) do 
    {
      'storm_user_name' => 'storm',
      'storm_storage_root_directory' => '/storage'
    }
  end

  it { is_expected.to contain_file('/storage')
    .with(
      :ensure => 'directory',
    )
  }

end
