#
class riemann::server::config::logging (
  $options = {
    'file' => "\"${riemann::server::params::log_file}\""
  }
) {
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = "\n;end ${title}"
  }
  if $options {
    $options_str = [':',join(join_keys_to_values($options,' '),' :')]
  }
  riemann::server::config::fragment { "riemann_server_config_${title}":
    content => "${debug_header}(logging/init {${options_str}})${debug_footer}",
    order   => '12'
  }
}
