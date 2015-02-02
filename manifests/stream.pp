#
define riemann::stream (
  $content = $title,
  $publish = false,
)
{
  include ::riemann
  include ::riemann::streams

  if $riemann::debug {
    $debug_header = ";begin stream ${title}\n"
    $debug_footer = "\n;end stream ${title}"
  }
  
  if is_array($content) {
    $sexpr = sexpr($content,1)
  }
  elsif is_string($content) {
    $sexpr = "(${content})"
  } else {
    fail("riemann::stream `${title}` is neither of type array or string")
  }
  @riemann::config::fragment { "stream ${title}":
    section => 'streams',
    content => "${debug_header}  ${sexpr}${debug_footer}"
  }
}
