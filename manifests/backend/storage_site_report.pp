# @summary Starting from Puppet module v2.0.0, the management of Storage Site Report has been improved.
#  Site administrators can add script and cron described in the [how-to](http://italiangrid.github.io/storm/documentation/how-to/how-to-publish-json-report/)
#  by using this defined type.
#
# @example
#   class { 'storm::backend':
#     # ...
#   }
#   storm::backend::storage_site_report { 'storage-site-report':
#     report_path => '/storage/info/report.json', # the internal storage area path
#     minute      => '*/20', # set cron's minute
#   }
#
# @param report_path
#   The full path of the generated report. Usually it points to a "info" storage area.
#
# @param minute
#   The cron job's minute parameter. Refer to [Resource Type cron](https://puppet.com/docs/puppet/5.5/types/cron.html#cron-attribute-minute).
#
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
