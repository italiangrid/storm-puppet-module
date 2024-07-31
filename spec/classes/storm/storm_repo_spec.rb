require 'spec_helper'

describe 'storm::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'check default configuration' do
        case facts[:operatingsystem]
        when 'CentOS', 'Scientific'
          case facts[:operatingsystemmajrelease]
          when '7'
            it 'storm-stable-centos7 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-stable-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/centos7/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-centos7 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-beta-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-beta/centos7/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-nightly-centos7 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-nightly-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-nightly/centos7/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
          end
        when 'RedHat', 'AlmaLinux'
          case facts[:operatingsystemmajrelease]
          when '9'
            it 'storm-stable-redhat9 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-stable-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/redhat9/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-redhat9 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-beta-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-beta/redhat9/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-nightly-redhat9 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-nightly-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-nightly/redhat9/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
          end
        end
      end

      context 'check all installed and stable disabled' do
        let(:params) do
          {
            enabled: ['nightly', 'beta'],
          }
        end

        case facts[:operatingsystem]
        when 'CentOS', 'Scientific'
          case facts[:operatingsystemmajrelease]
          when '7'
            it 'storm-stable-centos7 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-stable-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/centos7/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-centos7 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-beta-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-beta/centos7/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-nightly-centos7 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-nightly-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-nightly/centos7/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
          end
        when 'RedHat', 'AlmaLinux'
          case facts[:operatingsystemmajrelease]
          when '9'
            it 'storm-stable-redhat9 is installed but disabled' do
              is_expected.to contain_yumrepo('storm-stable-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/redhat9/',
                enabled: 0,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-redhat9 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-beta-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-beta/redhat9/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-nightly-redhat9 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-nightly-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-nightly/redhat9/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
          end
        end
      end

      context 'check only stable installed and enabled' do
        let(:params) do
          {
            installed: ['stable'],
          }
        end

        case facts[:operatingsystem]
        when 'CentOS', 'Scientific'
          case facts[:operatingsystemmajrelease]
          when '7'
            it 'storm-stable-centos7 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-stable-centos7').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/centos7/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-centos7 is not present' do
              is_expected.not_to contain_yumrepo('storm-beta-centos7')
            end
            it 'storm-nightly-centos7 is not present' do
              is_expected.not_to contain_yumrepo('storm-nightly-centos7')
            end
          end
        when 'RedHat', 'AlmaLinux'
          case facts[:operatingsystemmajrelease]
          when '9'
            it 'storm-stable-redhat9 is installed and enabled' do
              is_expected.to contain_yumrepo('storm-stable-redhat9').with(
                ensure: 'present',
                baseurl: 'https://repo.cloud.cnaf.infn.it/repository/storm-rpm-stable/redhat9/',
                enabled: 1,
                protect: 1,
                gpgcheck: 0,
                priority: 1,
              )
            end
            it 'storm-beta-redhat9 is not present' do
              is_expected.not_to contain_yumrepo('storm-beta-redhat9')
            end
            it 'storm-nightly-redhat9 is not present' do
              is_expected.not_to contain_yumrepo('storm-nightly-redhat9')
            end
          end
        end
      end

      context 'check custom urls' do
        let(:params) do
          {
            extra: [{
              'name' => 'test',
              'baseurl' => 'https://ci.cloud.cnaf.infn.it/rpms',
            }],
          }
        end

        it 'check extra repo is installed and enabled' do
          is_expected.to contain_yumrepo('test').with(
            ensure: 'present',
            baseurl: 'https://ci.cloud.cnaf.infn.it/rpms',
            enabled: 1,
            protect: 1,
            gpgcheck: 0,
            priority: 1,
          )
        end
      end
    end
  end
end
