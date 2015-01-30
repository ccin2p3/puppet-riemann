#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::profile::proxy
#
# This profile implements a Riemann forwarder
# which is basically a Riemann server which will
# automatically forward to all hosts which
# subscribe to it
#
class riemann::profile::proxy () inherits riemann::profile
{
  include ::riemann::server
  include ::riemann::publish
}
# vim: ft=puppet
