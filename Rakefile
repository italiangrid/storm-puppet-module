require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'puppet-strings/tasks'
require 'rspec/core/rake_task'

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ["vendor/**/*.pp", "spec/**/*.pp"]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

RSpec::Core::RakeTask.new(:spec_report_html) do |t|
  t.pattern = 'spec/{classes,defines,unit,functions,templates}/**/*_spec.rb'
  t.rspec_opts = [
    '--format documentation',
    '--color',
    '--profile',
    '--format html',
    '--out rspec_report.html',
  ]
end

RSpec::Core::RakeTask.new(:spec_report_xml) do |t|
  t.pattern = 'spec/{classes,defines,unit,functions,templates}/**/*_spec.rb'
  t.rspec_opts = [
    '--format documentation',
    '--color',
    '--profile',
    '--format RspecJunitFormatter',
    '--out rspec_report.xml',
  ]
end

desc "Validate, lint and test running"
task :test do
  Rake::Task[:validate].invoke
  Rake::Task[:metadata_lint].invoke
  Rake::Task[:lint].invoke
  Rake::Task[:spec_report_html].invoke
end

desc "Build report xml"
task :report_xml do
  Rake::Task[:spec_report_xml].invoke
end
