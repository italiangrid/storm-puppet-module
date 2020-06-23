RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-facts'
require 'rspec-puppet-utils'
require 'nokogiri'

include RspecPuppetFacts

# Add the 'root_home' fact to all tests
add_custom_fact :root_home, '/root'

# rspec 2.x doesn't have RSpec::Support, so fall back to File::ALT_SEPARATOR to
# detect if running on windows
def windows?
  return @windowsp unless @windowsp.nil?
  @windowsp = defined?(RSpec::Support) ? RSpec::Support::OS.windows? : !!File::ALT_SEPARATOR
end

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|

  c.pattern = 'spec/{classes,defines,unit,functions,templates}/**/*_spec.rb'

  default_facts = {
    puppetversion: Puppet.version,
    facterversion: Facter.version
  }
  c.default_facts = default_facts

  c.module_path     = File.join(fixture_path, 'modules')
  c.manifest_dir    = File.join(fixture_path, 'manifests')
  c.manifest        = File.join(fixture_path, 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')
  c.parser          = ENV['FUTURE_PARSER'] == 'yes' ? 'future' : 'current'

  c.after(:suite) do
     RSpec::Puppet::Coverage.report!(80)
  end
end
