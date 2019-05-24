require 'spec_helper'

describe 'storm::webdav::config' do

  let(:facts) { { :osfamily => 'RedHat' } }

  it { is_expected.to compile }

  context 'define one test storage area' do

    let(:params) do 
      {
        'storage_area' => [
          {
            'name' => 'test.vo'
          }
        ]
      }
    end

    it { is_expected.to contain_file('/etc/storm/webdav/sa.d').with( 
      :owner  => 'root',
      :group  => 'storm',
      :mode   => '0750',
      :ensure => 'directory'
    )}

    it "check storage area properties files exist" do
      is_expected.to contain_file('/etc/storm/webdav/sa.d/test.vo.properties').with(
        :ensure => 'present'
      )
    end

  end

end
