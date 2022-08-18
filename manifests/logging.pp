#
class riemann::logging (
  $options,
) {
  include riemann
  if $riemann::debug {
    $debug_header = ";begin ${title}\n"
    $debug_footer = "\n;end ${title}"
  } else {
    $debug_header = ''
    $debug_footer = ''
  }
  if $options {
    $options_str = join([':',join(join_keys_to_values($options,' '),' :')],'')
  } else {
    $options_str = ''
  }
  riemann::config::fragment { $title:
    content => "${debug_header}(logging/init {${options_str}})${debug_footer}",
    order   => '12',
  }
}
