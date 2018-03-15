#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Class riemann::profile::subscriber
#
# This profile is the base class for
# profiles subscribing to riemann::profile::proxy
#
class riemann::profile::subscriber
{
  include ::riemann
  include ::riemann::profile
  include ::riemann::subscription
}
# vim: ft=puppet
