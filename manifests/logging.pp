#
class riemann::logging (
  $options = undef
) {
  include riemann
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = "\n;end ${title}"
  }
  if $options {
    $options_str = join([':',join(join_keys_to_values($options,' '),' :')],'')
  }else {
    $options_str = ":file \"${::riemann::log_file}\""
  }
  riemann::config::fragment { $title:
    content => "${debug_header}(logging/init {${options_str}})${debug_footer}",
    order   => '12'
  }
}
