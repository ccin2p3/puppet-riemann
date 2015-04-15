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
  $content = ['',''],
  $streams = 'default'
)
{
  # validation
  validate_array($content)
  if (!count($content) == 2) {
    fail("published stream `${title}`: array 'stream' should contain exactly 2 elements")
  }
  if !defined(Riemann::Streams[$streams]) {
    riemann::streams { $streams: }
  }
  @riemann::config::fragment { "stream ${streams} publish ${title} part1":
    content    => $content[0],
    section    => "streams ${streams}",
    subscriber => 'local',
    order      => "20-streams-${title}-23"
  }
  @riemann::config::fragment { "stream ${streams} publish ${title} part3":
    content    => $content[1],
    section    => "streams ${streams}",
    subscriber => 'local',
    order      => "20-streams-${title}-26"
  }
  
}
# vim: ft=puppet
