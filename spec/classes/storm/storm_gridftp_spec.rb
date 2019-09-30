require 'spec_helper'

describe 'storm::gridftp', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end
    
      context 'Use custom gridftp params' do

        let(:params) do 
          {
            'port'            => 2911,
            'port_range'      => '30000,40000',
            'connections_max' => 4000,
          }
        end

        it "check gridftp conf file content" do
          title='gftp::configure-gridftp-conf-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/gridftp.conf',
          )
          is_expected.to contain_file(title).with( :content => /port 2911/ )
          is_expected.to contain_file(title).with( :content => /port_range 30000,40000/ )
          is_expected.to contain_file(title).with( :content => /connections_max 4000/ )
        end
      end

      context 'Use default gridftp params' do

        it "check gridftp conf file content" do
          title='gftp::configure-gridftp-conf-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/gridftp.conf',
          )
          is_expected.to contain_file(title).with( :content => /port 2811/ )
          is_expected.to contain_file(title).with( :content => /port_range 20000,25000/ )
          is_expected.to contain_file(title).with( :content => /connections_max 2000/ )
        end
      end
    end
  end
end