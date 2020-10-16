require 'spec_helper'

describe 'storm::webdav::application_file' do

  on_supported_os.each do |os, facts|

    context "on #{os}" do

      let(:pre_condition) do
        <<-EOF
          class { 'storm::webdav':
            hostnames => ['storm.webdav.org'],
          }
        EOF
      end
      
      let(:facts) do
        facts
      end

      let(:title) { 'application.yml' }

      let(:params) do
        {
          'source' => '/path/to/application.yml',
        }
      end

      it "check application file exists" do
        application_file='/etc/storm/webdav/config/application.yml'
        is_expected.to contain_file(application_file).with(
          :source => '/path/to/application.yml',
        )
      end

    end
  end
end