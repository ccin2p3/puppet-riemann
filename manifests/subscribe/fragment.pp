#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Define riemann::subscribe::fragment
#
# This defined type implements subscribe fragments
# which are the exported config snippets resposible for
# forwarding streams from one riemann server to another
#
define riemann::subscribe::fragment (
  $content,
  $order = '42',
  $target = false,
)
{
  ::concat::fragment { $title:
    content => $content,
    target  => $target,
    order   => $order
  }
}
