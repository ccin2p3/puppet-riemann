#
# Class: riemann::streams
#
# this class will call (streams ...) in a riemann config
# and construct its contents using riemann::stream defines
#
define riemann::streams (
  $let = [],
  $order = "50-${title}"
)
{
  include riemann
  # let
  riemann::config::fragment { "let ${title} header":
    content => '(let [',
    order   => "${order}-00"
  }
  # let items given as params
  if (is_array($let)) {
    $let_body = join($let,' ')
  } elsif (is_hash($let)) {
    $let_body = join(sort(join_keys_to_values($let,' ')),' ')
  } elsif (is_string($let)) {
    $let_body = $let
  } else {
    fail("streams: 'let' must be array, hash or string")
  }
  riemann::config::fragment { "let ${title} body":
    content => "      ${let_body}",
    order   => "${order}-10"
  }
  # collect virtual and exported let items from riemann::let
  Riemann::Config::Fragment <| section == "let streams ${title}" and subscriber == 'local' |> {
    order   => "${order}-12"
  }
  Riemann::Config::Fragment <<| section == "let streams ${title}" and puppet_environment == $::environment and subscriber != $::clientcert |>> {
    order   => "${order}-13"
  }
  riemann::config::fragment { "let ${title} body end":
    content => ']',
    order   => "${order}-15"
  }
  riemann::config::fragment { "streams ${title} header":
    content => '(streams',
    order   => "${order}-20"
  }
  # collect stream functions from riemann::stream
  Riemann::Config::Fragment <| section == "streams ${title}" and subscriber == 'local' |> {
    order   => "${order}-25"
  }
  # collect stream functions from exported riemann::subscribe
  Riemann::Config::Fragment <<| section == "streams ${title}" and puppet_environment == $::environment and subscriber != $::clientcert |>> {
    order   => "${order}-25"
  }
  riemann::config::fragment { "streams ${title} footer":
    content => ')',
    order   => "${order}-28"
  }
  riemann::config::fragment { "let ${title} footer":
    content => ')',
    order   => "${order}-99"
  }
}
