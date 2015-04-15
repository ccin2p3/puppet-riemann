#
define riemann::stream (
  $content = $title,
  $streams = 'default',
)
{
  include ::riemann
  if !defined(Riemann::Streams[$streams]) {
    riemann::streams { $streams: }
  }

  $sexpr = sexpr($content,1)
  @riemann::config::fragment { "stream ${title}":
    section => "streams ${streams}",
    content => $sexpr
  }
}
