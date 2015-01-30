#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::server
#
# This class implements the riemann service
# it will in a nutshell make sure the package, config and service
# resources for the riemann streams processor are managed
# http://riemann.io
#
class riemann::server (
  $package_name = $riemann::server::params::package_name,
  $service_name = $riemann::server::params::service_name,
  $config_dir = $riemann::server::params::config_dir,
  $config_include_dir = $riemann::server::params::config_include_dir,
  $init_config_file = $riemann::server::params::init_config_file,
  $reload_command = $riemann::server::params::reload_command,
) inherits riemann::server::params {

  # validate parameters here

  include ::riemann
  $debug = $riemann::debug
  class { 'riemann::server::install': } ->
  class { 'riemann::server::config': } ~>
  class { 'riemann::server::service': } ->
  Class['riemann::server']
}
# vim: ft=puppet
