require 'spec_helper'

describe 'storm::repo' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:facts) do
        facts
      end
  
      context 'check default configuration' do

        case facts[:operatingsystemmajrelease]
        when '6'
          it "check stable repo" do
            is_expected.to contain_yumrepo('storm-stable-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el6/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo" do
            is_expected.to contain_yumrepo('storm-beta-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/beta/el6/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check nightly repo" do
            is_expected.to contain_yumrepo('storm-nightly-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/nightly/el6/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
        when '7'
          it "check stable repo" do
            is_expected.to contain_yumrepo('storm-stable-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el7/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo" do
            is_expected.to contain_yumrepo('storm-beta-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/beta/el7/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check nightly repo" do
            is_expected.to contain_yumrepo('storm-nightly-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/nightly/el7/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
        end
      end

      context 'check all installed and stable disabled' do

        let(:params) do 
          {
            :enabled => ['nightly', 'beta'],
          }
        end
    
        case facts[:operatingsystemmajrelease]
        when '6'
          it "check stable repo installed but disabled" do
            is_expected.to contain_yumrepo('storm-stable-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el6/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo is enabled" do
            is_expected.to contain_yumrepo('storm-beta-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/beta/el6/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check nightly repo is enabled" do
            is_expected.to contain_yumrepo('storm-nightly-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/nightly/el6/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
        when '7'
          it "check stable repo installed but disabled" do
            is_expected.to contain_yumrepo('storm-stable-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el7/x86_64/',
              :enabled  => 0,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo is enabled" do
            is_expected.to contain_yumrepo('storm-beta-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/beta/el7/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check nightly repo is enabled" do
            is_expected.to contain_yumrepo('storm-nightly-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/nightly/el7/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
        end

      end

      context 'check only stable installed and enabled' do

        let(:params) do 
          {
            :installed => ['stable'],
          }
        end
    
        case facts[:operatingsystemmajrelease]
        when '6'
          it "check stable repo installed and enabled" do
            is_expected.to contain_yumrepo('storm-stable-centos6').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el6/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo not installed" do
            is_expected.to_not contain_yumrepo('storm-beta-centos6')
          end
          it "check nightly repo is enabled" do
            is_expected.to_not contain_yumrepo('storm-nightly-centos6')
          end
        when '7'
          it "check stable repo installed and enabled" do
            is_expected.to contain_yumrepo('storm-stable-centos7').with( 
              :ensure   => 'present',
              :baseurl  => 'https://repo.cloud.cnaf.infn.it/repository/storm/stable/el7/x86_64/',
              :enabled  => 1,
              :protect  => 1,
              :gpgcheck => 0,
              :priority => 1,
            )
          end
          it "check beta repo not installed" do
            is_expected.to_not contain_yumrepo('storm-beta-centos7')
          end
          it "check nightly repo is enabled" do
            is_expected.to_not contain_yumrepo('storm-nightly-centos7')
          end
        end

      end

      context 'check custom urls' do

        let(:params) do 
          {
            :extra => [{
              'name' => 'test',
              'baseurl' => 'https://ci.cloud.cnaf.infn.it/rpms'
            }],
          }
        end

        it "check extra repo is installed and enabled" do
          is_expected.to contain_yumrepo('test').with( 
            :ensure   => 'present',
            :baseurl  => 'https://ci.cloud.cnaf.infn.it/rpms',
            :enabled  => 1,
            :protect  => 1,
            :gpgcheck => 0,
            :priority => 1,
          )
        end
      end

    end
  end

end