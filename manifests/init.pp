#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann
#
# This class manages the riemann streams processor
# http://riemann.io
# It will make sure the package, config and service
# resources for riemann are present
#
class riemann (
  $use_hiera,
  $package_name,
  $service_name,
  $config_dir,
  $config_include_dir,
  $manage_init_defaults,
  $init_config_hash,
  $init_config_file,
  $log_file,
  $reload_command,
  $validate_cmd,
  $test_before_reload,
  Pattern['^::'] $pubsub_var,
  $debug,
) {
  class { 'riemann::install': }
  -> class { 'riemann::config': }
  ~> class { 'riemann::service': }
  -> Class['riemann']

  if ($use_hiera) {
    include '::riemann::hiera'
  }
}
# vim: ft=puppet
