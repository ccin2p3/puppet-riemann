#
define riemann::server::config::listen (
  $type = $title,
  $options = false
) {
  if $riemann::debug {
    $debug_header = ";begin riemann::server::config::listen `${title}`\n"
    $debug_footer = "\n;end riemann::server::config::listen `${title}`"
  }
  if $options {
    $options_str = [' :',join(join_keys_to_values($options,' '),' :')]
  }
  riemann::server::config::fragment { "riemann_server_config_${title}":
    content => "${debug_header}(${type}-server${options_str})${debug_footer}",
    order   => '15'
  }
}
