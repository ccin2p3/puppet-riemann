#
class riemann::logging (
  $options = {
    'file' => "\"${::riemann::log_file}\""
  }
) {
  include riemann
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = "\n;end ${title}"
  } else {
    $debug_header = ''
  }
  if $options {
    $options_str = join([':',join(join_keys_to_values($options,' '),' :')],'')
  }
  riemann::config::fragment { $title:
    content => "${debug_header}(logging/init {${options_str}})${debug_footer}",
    order   => '12'
  }
}
