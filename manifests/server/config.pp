#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::server::config
#
# This class is called from riemann::server
# It makes sure riemann's configuration file is present
#
class riemann::server::config {
  $debug = $riemann::debug
  if $debug {
    $debug_header = ";begin ${title}"
    $debug_footer = ";end ${title}"
  }
  $config_dir = $::riemann::server::config_dir
  $config_include_dir = $::riemann::server::config_include_dir
  file { $config_dir:
    ensure => directory
  } ->
  file { "${config_dir}/${config_include_dir}":
    ensure => directory
  } ->
  concat { 'riemann_server_config':
    ensure  => present,
    path    => "${config_dir}/riemann.config",
  }
  riemann::server::config::fragment { 'riemann_server_config_header':
    content => template('riemann/riemann.config-header.erb'),
    order   => '00'
  }
  riemann::server::config::fragment { 'riemann_server_config_footer':
    content => template('riemann/riemann.config-footer.erb'),
    order   => '999'
  }
}
# vim: ft=puppet
