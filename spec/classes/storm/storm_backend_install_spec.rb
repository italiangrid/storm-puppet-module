require 'spec_helper'

describe 'storm::backend::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'test fs_type = posixfs' do
        let(:pre_condition) do
          <<-EOF
            class { 'storm::backend':
              hostname => 'storm.example.org',
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check storm backend metapackage is installed' do
          is_expected.to contain_package('storm-backend-mp').with(ensure: 'installed')
        end
        it 'check storm native libs gpfs not installed' do
          is_expected.not_to contain_package('storm-native-libs-gpfs')
        end
        it 'check storm info provider is installed' do
          is_expected.to contain_package('storm-dynamic-info-provider').with(ensure: 'installed')
        end
      end

      context 'test fs_type = gpfs with install_native_libs_gpfs = false' do
        let(:pre_condition) do
          <<-EOF
            class { 'storm::backend':
              hostname => 'storm.example.org',
              fs_type => 'gpfs',
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check failure' do
          is_expected.to compile.and_raise_error(%r{You have declared fs_type as 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.})
        end
      end

      context 'test storage area has fs_type = gpfs with install_native_libs_gpfs = false' do
        let(:pre_condition) do
          <<-EOF
            class { 'storm::backend':
              hostname => 'storm.example.org',
              storage_areas => [
                {
                  name => 'test.vo',
                  root_path => '/storage/test.vo',
                  access_points => ['/test.vo'],
                  vos => ['test.vo', 'test.vo.2'],
                  storage_class => 'T0D1',
                  online_size => 4,
                  nearline_size => 10,
                  fs_type => 'gpfs',
                  transfer_protocols => ['file','gsiftp','webdav','xroot'],
                },
              ],
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check failure' do
          is_expected.to compile.and_raise_error(%r{Storage area test.vo is 'gpfs' but 'install_native_libs_gpfs' is false. Check your configuration.})
        end
      end

      context 'test fs_type = gpfs with install_native_libs_gpfs = true' do
        let(:pre_condition) do
          <<-EOF
            class { 'storm::backend':
              hostname => 'storm.example.org',
              install_native_libs_gpfs => true,
              fs_type => 'gpfs',
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check storm backend metapackage is installed' do
          is_expected.to contain_package('storm-backend-mp').with(ensure: 'installed')
        end
        it 'check storm native libs gpfs is installed' do
          is_expected.to contain_package('storm-native-libs-gpfs').with(ensure: 'installed')
        end
        it 'check storm info provider is installed' do
          is_expected.to contain_package('storm-dynamic-info-provider').with(ensure: 'installed')
        end
      end

      context 'test storage area has fs_type = gpfs with install_native_libs_gpfs = true' do
        let(:pre_condition) do
          <<-EOF
            class { 'storm::backend':
              hostname => 'storm.example.org',
              install_native_libs_gpfs => true,
              storage_areas => [
                {
                  name => 'test.vo',
                  root_path => '/storage/test.vo',
                  access_points => ['/test.vo'],
                  vos => ['test.vo'],
                  storage_class => 'T0D1',
                  online_size => 4,
                  nearline_size => 10,
                  fs_type => 'gpfs',
                },
              ],
              gsiftp_pool_members => [
                {
                  hostname => 'gridftp-0.example.org',
                },
              ],
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check storm backend metapackage is installed' do
          is_expected.to contain_package('storm-backend-mp').with(ensure: 'installed')
        end
        it 'check storm native libs gpfs is installed' do
          is_expected.to contain_package('storm-native-libs-gpfs').with(ensure: 'installed')
        end
        it 'check storm info provider is installed' do
          is_expected.to contain_package('storm-dynamic-info-provider').with(ensure: 'installed')
        end
      end
    end
  end
end
