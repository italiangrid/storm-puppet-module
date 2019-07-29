require 'spec_helper'

describe 'storm::gridftp', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end
    
      context 'Use custom configuration' do

        let(:params) do 
          {
            'gridftp_with_dsi'   => 'yes',
            'tcp_port_range_min' => 30000,
            'tcp_port_range_max' => 40000,
            'connections_max'    => 4000,
          }
        end

        it "check profile.d script content" do
          title='gftp::configure-profiled-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/profile.d/storm-globus-gridftp.sh',
          )
          is_expected.to contain_file(title).with( :content => /export GLOBUS_TCP_PORT_RANGE="30000,40000"/ )
          is_expected.to contain_file(title).with( :content => /export GRIDFTP_WITH_DSI="yes"/ )
        end

        it "check gridftp conf file content" do
          title='gftp::configure-gridftp-conf-file'
          is_expected.to contain_file(title).with( 
            :ensure => 'present',
            :path   => '/etc/grid-security/gridftp.conf',
          )
          is_expected.to contain_file(title).with( :content => /connections_max 4000/ )
        end
      end
    end
  end
end