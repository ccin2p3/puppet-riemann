require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'   

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_140chars')

ignore_paths = ['vendor/**/*', 'spec/**/*', 'smoke/**/*', 'pkg/**/*']

PuppetSyntax.exclude_paths = ignore_paths

#PuppetLint.configuration.ignore_paths = ignore_paths
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ignore_paths
end

task :default => [:spec, :lint]
