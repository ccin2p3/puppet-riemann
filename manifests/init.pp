#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class: riemann
#
# Full description of class riemann here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class riemann (
  $package_name = $riemann::params::package_name,
  $service_name = $riemann::params::service_name,
) inherits riemann::params {

  # validate parameters here

  class { 'riemann::install': } ->
  class { 'riemann::config': } ~>
  class { 'riemann::service': } ->
  Class['riemann']
}
# vim: ft=puppet
