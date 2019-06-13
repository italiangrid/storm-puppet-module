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
          it "check stable repo exists and is enabled" do
            is_expected.to contain_exec('download-stable-repo-el6')
            is_expected.to contain_exec('enable-stable-repo-el6')
          end

          it "check beta repo exists and is disabled" do
            is_expected.to contain_exec('download-beta-repo-el6')
            is_expected.to contain_exec('disable-beta-repo-el6')
          end

          it "check nighlty repo exists and is disabled" do
            is_expected.to contain_exec('download-nightly-repo-el6')
            is_expected.to contain_exec('disable-nightly-repo-el6')
          end
        when '7'
          it "check stable repo exists and is enabled" do
            is_expected.to contain_exec('download-stable-repo-el7')
            is_expected.to contain_exec('enable-stable-repo-el7')
          end

          it "check beta repo exists and is disabled" do
            is_expected.to contain_exec('download-beta-repo-el7')
            is_expected.to contain_exec('disable-beta-repo-el7')
          end

          it "check nighlty repo exists and is disabled" do
            is_expected.to contain_exec('download-nightly-repo-el7')
            is_expected.to contain_exec('disable-nightly-repo-el7')
          end
        end

      end

      context 'check custom configuration' do

        let(:params) do 
          {
              :enabled => ['nightly', 'beta'],
          }
        end
    
        case facts[:operatingsystemmajrelease]
        when '6'

          it "check stable repo exists and is enabled" do
            is_expected.to contain_exec('download-stable-repo-el6')
            is_expected.to contain_exec('disable-stable-repo-el6')
          end
          it "check beta repo exists and is disabled" do
            is_expected.to contain_exec('download-beta-repo-el6')
            is_expected.to contain_exec('enable-beta-repo-el6')
          end
          it "check nighlty repo exists and is disabled" do
            is_expected.to contain_exec('download-nightly-repo-el6')
            is_expected.to contain_exec('enable-nightly-repo-el6')
          end
        when '7'
          it "check stable repo exists and is enabled" do
            is_expected.to contain_exec('download-stable-repo-el7')
            is_expected.to contain_exec('disable-stable-repo-el7')
          end
          it "check beta repo exists and is disabled" do
            is_expected.to contain_exec('download-beta-repo-el7')
            is_expected.to contain_exec('enable-beta-repo-el7')
          end
          it "check nighlty repo exists and is disabled" do
            is_expected.to contain_exec('download-nightly-repo-el7')
            is_expected.to contain_exec('enable-nightly-repo-el7')
          end
        end

      end

    end
  end

  context 'check custom urls' do

    let(:params) do 
      {
        :installed => [],
        :customs => [{
          'name' => 'test',
          'url' => 'https://ci.cloud.cnaf.infn.it/view/storm/job/pkg.storm/job/release-el6-1-11-16/lastSuccessfulBuild/artifact/rpms/storm-test-centos6.repo'
        }],
      }
    end

    it "check repo has been downloaded" do
      is_expected.to contain_exec('download-custom-test-repo')
    end

  end

end