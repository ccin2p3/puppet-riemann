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
  
  $sexpr = sexpr($content,1)
  @riemann::config::fragment { "stream ${title}":
    section => 'streams',
    content => "${debug_header}  ${sexpr}${debug_footer}"
  }
}
