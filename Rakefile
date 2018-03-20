require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.log_format = '%<path>s:%<linenumber>s:%<check>s:%<KIND>s:%<message>s'
PuppetLint.configuration.fail_on_warnings = true

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.send('disable_class_parameter_defaults')
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_80chars')
# PuppetLint.configuration.send('disable_arrow_alignment')

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*',
  'smoke/**/*.pp'
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run syntax and spec tests.'
task test: %i[
  syntax
  spec
]
