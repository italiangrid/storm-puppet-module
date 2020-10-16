# @summary
define storm::backend::storage_site_report (
  String $report_path,
  String $minute = '*/30',
) {

  # Storage Site Report
  $report_script='/etc/storm/backend-server/update-site-report.sh'
  $report_command="/bin/bash ${report_script} ${report_path}"

  # script
  file { $report_script:
    ensure => 'present',
    source => 'puppet:///modules/storm/update-site-report.sh',
  }

  # cron
  cron { 'update-site-report':
    ensure  => 'present',
    command => $report_command,
    user    => 'root',
    minute  => $minute,
    require => File[$report_script],
  }

  # first execution
  exec { 'create-site-report':
    command => $report_command,
    creates => $report_path,
    require => [File[$report_script], Class['storm::backend']],
  }
}
