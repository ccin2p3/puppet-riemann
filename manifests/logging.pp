#
class riemann::logging (
  $options = {
    'file' => "\"${riemann::params::log_file}\""
  }
) {
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = "\n;end ${title}"
  }
  if $options {
    $options_str = [':',join(join_keys_to_values($options,' '),' :')]
  }
  riemann::config::fragment { "riemann_server_config_${title}":
    content => "${debug_header}(logging/init {${options_str}})${debug_footer}",
    order   => '12'
  }
}
