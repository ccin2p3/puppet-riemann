#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Define riemann::server::config::fragment
#
# This defined type implements config fragments
# for riemann::server::config
#
define riemann::server::config::fragment (
  $content,
  $section = 'root',
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
