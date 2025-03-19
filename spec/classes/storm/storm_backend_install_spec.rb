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
          is_expected.to contain_package('storm-backend-server')
        end
        it 'check storm native libs gpfs not installed' do
          is_expected.not_to contain_package('storm-native-libs-gpfs')
        end
        it 'check storm info provider is installed' do
          is_expected.to contain_package('storm-dynamic-info-provider')
        end
      end

      context 'test cofngiruation fs_type = gpfs' do
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

        it 'check storm native libs gpfs are installed' do
          is_expected.to contain_package('storm-native-libs-gpfs')
        end
      end

      context 'test storage area configuration has fs_type = gpfs' do
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
                },
              ],
              gsiftp_pool_members => [
                {
                  hostname => 'storm.example.org',
                },
              ],
            }
          EOF
        end
        let(:facts) do
          facts
        end

        it 'check storm native libs gpfs are installed' do
          is_expected.to contain_package('storm-native-libs-gpfs')
        end
      end
    end
  end
end
