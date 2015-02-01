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
  $package_name = $riemann::params::package_name,
  $service_name = $riemann::params::service_name,
  $config_dir = $riemann::params::config_dir,
  $config_include_dir = $riemann::params::config_include_dir,
  $init_config_file = $riemann::params::init_config_file,
  $reload_command = $riemann::params::reload_command,
  $debug = false
) inherits riemann::params {

  # validate parameters here

  class { 'riemann::install': } ->
  class { 'riemann::config': } ~>
  class { 'riemann::service': } ->
  Class['riemann']
}
# vim: ft=puppet
