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
  $subscriber = $trusted['clientcert'],
  $pubsub_var = getvar($riemann::pubsub_var)
)
{
  ::concat::fragment { "riemann::config ${title}":
    content => riemann::sexpr($content),
    target  => 'riemann_config',
    order   => $order,
  }
}
