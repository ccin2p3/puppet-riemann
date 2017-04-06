#
define riemann::listen (
  $type = $title,
  $options = ''
) {
  if $riemann::debug {
    $debug_header = ";begin riemann::listen `${title}`\n"
    $debug_footer = "\n;end riemann::listen `${title}`"
  } else {
    $debug_header = ''
    $debug_footer = ''
  }
  riemann::config::fragment { "listen_${title}":
    content => [ "${type}-server", $options ],
    order   => '15'
  }
}
