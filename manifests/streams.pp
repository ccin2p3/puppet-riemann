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
  $header_content = "${debug_header}(streams\n"
  $footer_content = "${debug_footer})\n"
  # header
  riemann::server::config::fragment { 'streams header':
    target  => 'riemann_server_config',
    content => $header_content,
    order   => '20-streams-00',
  }
  # collect stream
  Riemann::Server::Config::Fragment <| section == 'streams' |> {
    target => 'riemann_server_config',
    order  => '20-streams-10',
  }
  # publish to subscribers
  if $publish {
    riemann::stream::publish { $pubclass: }
  }
  # footer
  riemann::server::config::fragment { 'streams footer':
    target  => 'riemann_server_config',
    content => $footer_content,
    order   => '20-streams-99',
  }
}
