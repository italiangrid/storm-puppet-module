require 'rspec-puppet'
require 'rspec-puppet-facts'
require 'rspec-puppet-utils'
require 'rspec-puppet-augeas'

include RspecPuppetFacts

if ENV['COVERAGE'] == 'yes'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter(/^\/spec\//)
  end
end

# rspec 2.x doesn't have RSpec::Support, so fall back to File::ALT_SEPARATOR to
# detect if running on windows
def windows?
  return @windowsp unless @windowsp.nil?
  @windowsp = defined?(RSpec::Support) ? RSpec::Support::OS.windows? : !!File::ALT_SEPARATOR
end

RSpec.configure do |c|

  # Configure augeas fixture test directory
  c.augeas_fixtures = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'augeas')

  default_facts = {
    puppetversion: Puppet.version,
    facterversion: Facter.version
  }
  c.default_facts = default_facts

  c.module_path     = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'modules')
  c.manifest_dir    = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests')
  c.manifest        = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')
  c.parser          = ENV['FUTURE_PARSER'] == 'yes' ? 'future' : 'current'

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(80)
  end
end