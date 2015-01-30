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
  $content = $title,
  $section = 'root',
  $order = '42',
  $pubclass = 'default',
  $subscriber = $::clientcert
)
{
  ::concat::fragment { $title:
    content => $content,
    target  => 'riemann_server_config',
    order   => $order
  }
}
