#!/bin/bash

gem install rake
gem uninstall rake -v 12.3.2 -i /usr/local/lib/ruby/gems/2.6.0
gem install puppet -v '< 6.0'
gem install rspec
gem install rspec-puppet
gem install rspec-puppet-facts
gem install rspec-puppet-utils
gem install rspec-puppet-augeas
gem install puppetlabs_spec_helper -v '>= 1.2.0'
gem install jimdo-rspec-puppet-helpers
gem install metadata-json-lint
gem install simplecov -v '>= 0.11.0'
gem install simplecov-console
gem install codecov
gem install semantic_puppet
gem install facter -v '>= 1.7.0'
gem install puppet-strings
gem install nokogiri

gem install puppet-lint -v '>= 1.0.0'
gem install puppet-lint-absolute_classname-check
gem install puppet-lint-leading_zero-check
gem install puppet-lint-trailing_comma-check
gem install puppet-lint-version_comparison-check
gem install puppet-lint-classes_and_types_beginning_with_digits-check
gem install puppet-lint-unquoted_string-check
gem install puppet-lint-resource_reference_syntax

gem install rspec_junit_formatter
gem install git

# rubocop:disable Bundler/DuplicatedGem
gem install rubocop-rails
# rubocop:enable Bundler/DuplicatedGem

gem install better_errors
gem install binding_of_caller
gem install puppet-blacksmith
gem install guard-rake
gem install listen -v '~> 3.0.0'

# rubocop:disable Bundler/DuplicatedGem
gem install beaker
gem install beaker-rspec
# rubocop:enable Bundler/DuplicatedGem

gem install beaker-puppet_install_helper

gem cleanup