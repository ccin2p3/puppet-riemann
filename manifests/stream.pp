#
define riemann::stream (
  $content = $title
)
{
  include ::riemann::server
  include ::riemann::streams

  if $riemann::debug {
    $debug_header = ";begin stream ${title}\n"
    $debug_footer = "\n;end stream ${title}"
  }
  @riemann::server::config::fragment { "stream ${title}":
    section => 'streams',
    content => "${debug_header}  ${content}${debug_footer}"
  }
}
