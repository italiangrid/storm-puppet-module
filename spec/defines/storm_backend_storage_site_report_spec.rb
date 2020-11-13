require 'spec_helper'

describe 'storm::backend::storage_site_report' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
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

      let(:title) { 'storage-site-report' }

      let(:params) do
        {
          'report_path' => '/path/to/report.json',
          'minute' => '*/10',
        }
      end

      it 'check script exists' do
        script_file = '/etc/storm/backend-server/update-site-report.sh'
        is_expected.to contain_file(script_file)
      end

      it 'check cron exists and is well configured' do
        is_expected.to contain_cron('update-site-report').with(
          minute: '*/10',
        )
      end

      it 'check first exec' do
        is_expected.to contain_exec('create-site-report')
      end
    end
  end
end
