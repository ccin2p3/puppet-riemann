#
define riemann::listen (
  $type = $title,
  $options = false
) {
  if $riemann::debug {
    $debug_header = ";begin riemann::listen `${title}`\n"
    $debug_footer = "\n;end riemann::listen `${title}`"
  }
  if $options {
    #$options_str = [' :',join(join_keys_to_values($options,' '),' :')]
  }
  riemann::config::fragment { "listen_${title}":
    #content => "${debug_header}(${type}-server${options_str})${debug_footer}",
    content => [ "${type}-server", $options ],
    order   => '15'
  }
}
