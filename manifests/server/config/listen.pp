#
define riemann::server::config::listen (
  $type = $title,
  $options = false
) {
  if $riemann::debug {
    $debug_header = ";begin riemann::server::config::listen `${title}`\n"
    $debug_footer = ";end riemann::server::config::listen `${title}`\n"
  }
  if $options {
    $options_str = [' :',join(join_keys_to_values($options,' '),' :')]
  }
  riemann::server::config::fragment { "riemann_server_config_${title}":
    content => "${debug_header}(${type}-server${options_str})\n${debug_footer}",
    order   => '15'
  }
}
