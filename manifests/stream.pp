#
define riemann::stream (
  $content,
  $streams = 'default',
)
{
  include ::riemann::server
  if ! defined(Riemann::Streams[$streams]) {
    riemann::streams { $streams: }
  }

  if $riemann::debug {
    $debug_header = ";begin stream ${title}\n"
    $debug_footer = ";end stream ${title}\n"
  }
  @riemann::server::config::fragment { "stream ${title}":
    section => "streams ${streams}",
    content => "${debug_header}  ${content}\n${debug_footer}"
  }
}
