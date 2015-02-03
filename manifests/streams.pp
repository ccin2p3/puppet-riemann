#
# Class: riemann::streams
#
# this class will call (streams ...) in a riemann config
# and construct its contents using riemann::stream defines
#
class riemann::streams (
  $publish = true,
  $pubclass = ['default'],
)
{
  include riemann
  validate_bool($publish)
  validate_array($pubclass)
  if $riemann::debug {
    $debug_header = ';begin streams'
    $debug_footer = "\n;end streams"
  }
  $header_content = "${debug_header}\n(streams"
  $footer_content = ")${debug_footer}\n"
  # header
  riemann::config::fragment { 'streams header':
    content => $header_content,
    order   => '20-streams-00',
  }
  # collect stream
  Riemann::Config::Fragment <| section == 'streams' |> {
    order  => '20-streams-10',
  }
  # publish to subscribers
  if $publish {
    riemann::stream::publish { $pubclass: }
  }
  # footer
  riemann::config::fragment { 'streams footer':
    content => $footer_content,
    order   => '20-streams-99',
  }
}
