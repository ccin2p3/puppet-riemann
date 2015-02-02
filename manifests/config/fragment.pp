#
# Copyright (c) IN2P3 Computing Centre, IN2P3, CNRS
#
# Contributor(s) : ccin2p3
#

# == Define riemann::config::fragment
#
# This defined type implements config fragments
# for riemann::config
#
define riemann::config::fragment (
  $content = $title,
  $section = 'root',
  $order = '42',
  $pubclass = 'default',
  $subscriber = $::clientcert
)
{
  ::concat::fragment { $title:
    content => "${content}\n",
    target  => 'riemann_server_config',
    order   => $order
  }
}