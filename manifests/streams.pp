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
  validate_bool($publish)
  validate_array($pubclass)
  if $riemann::debug {
    $debug_header = ";begin streams\n"
    $debug_footer = ";end streams\n"
  }
  $header_content = "${debug_header}(streams"
  $footer_content = "${debug_footer})"
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
