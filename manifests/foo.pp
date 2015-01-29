#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::foo
# This class implements functionality 'foo'
# In this boilerplate the class includes 3 subclasses respectively responsible
# for providing Package, configuration and Service resources
#
class riemann::foo (
  $package_name = $riemann::foo::params::package_name,
  $service_name = $riemann::foo::params::service_name,
) inherits riemann::foo::params {

  # validate parameters here

  class { 'riemann::foo::install': } ->
  class { 'riemann::foo::config': } ~>
  class { 'riemann::foo::service': } ->
  Class['riemann::foo']
}
# vim: ft=puppet
