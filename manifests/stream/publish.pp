#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Define riemann::stream::publish
#
# This type implements a publishing rule for a riemann server
# it will configure forward async queues for all subscribing hosts
# i.e. the ones implementing riemann::subscribe
# see http://riemann.io/api/riemann.config.html
#
define riemann::stream::publish (
)
{
  #Riemann::Config::Fragment <<| section == 'subscription' and pubclass == $title and subscriber != $::clientcert |>> {
  Riemann::Config::Fragment <| section == 'subscription' and pubclass == $title and subscriber != $::clientcert |> {
    section => 'streams',
    order   => '20-streams-20'
  }
}
# vim: ft=puppet
