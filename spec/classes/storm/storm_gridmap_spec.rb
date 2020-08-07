require 'spec_helper'

describe 'storm::gridmap', :type => :class do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end
      let(:pre_condition) do
        <<-EOF
          class { 'storm::users': }
        EOF
      end

      gridmapdir='/etc/grid-security/gridmapdir'
      groupmapfile='/etc/grid-security/groupmapfile'
      gridmapfile='/etc/grid-security/grid-mapfile'

      context 'with default storm::gridmap' do

        it "check gridmap dir" do
          is_expected.to contain_file(gridmapdir).with( 
            :ensure => 'directory',
            :owner  => 'storm',
            :group  => 'storm',
            :mode   => '0770',
          )
        end

        it "check groupmapfile content" do
          is_expected.to contain_file(groupmapfile).with( :content => /"\/test.vo\/Role=NULL\/Capability=NULL" testvo/ )
          is_expected.to contain_file(groupmapfile).with( :content => /"\/test.vo" testvo/ )
          is_expected.to contain_file(groupmapfile).with( :content => /"\/test.vo.2\/Role=NULL\/Capability=NULL" testvodue/ )
          is_expected.to contain_file(groupmapfile).with( :content => /"\/test.vo.2" testvodue/ )
        end

        it "check grid-mapfile content" do
          is_expected.to contain_file(gridmapfile).with( :content => /"\/test.vo\/Role=NULL\/Capability=NULL" .tstvo/ )
          is_expected.to contain_file(gridmapfile).with( :content => /"\/test.vo" .tstvo/ )
          is_expected.to contain_file(gridmapfile).with( :content => /"\/test.vo.2\/Role=NULL\/Capability=NULL" .testdue/ )
          is_expected.to contain_file(gridmapfile).with( :content => /"\/test.vo.2" .testdue/ )
        end

        it "check test.vo pool account users" do

          is_expected.to contain_group('testvo').with(
            :ensure => 'present',
            :gid    => 7100,
          )
          
          (1..20).each do | i |
            name=sprintf('tstvo%03d', i)
            is_expected.to contain_user(name).with(
              :ensure => 'present',
              :uid    => 7100 + i,
              :gid    => 7100,
              :groups => ['testvo'],
            )
            path=sprintf('%s/%s', gridmapdir, name)
            is_expected.to contain_file(path).with( 
              :ensure  => 'present',
            )
          end
          
        end

        it "check test.vo.2 pool account users" do

          is_expected.to contain_group('testvodue').with(
            :ensure => 'present',
            :gid    => 8100,
          )

          (1..20).each do | i |
            name=sprintf('testdue%03d', i)
            is_expected.to contain_user(name).with(
              :ensure => 'present',
              :uid    => 8100 + i,
              :gid    => 8100,
              :groups => ['testvodue'],
            )
            path=sprintf('%s/%s', gridmapdir, name)
            is_expected.to contain_file(path).with( 
              :ensure  => 'present',
            )
          end
          
        end

      end

    end
  end
end