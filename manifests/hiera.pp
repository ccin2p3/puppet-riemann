#

class riemann::hiera (
  $hiera_prefix = ''
)
  {
  riemann::hiera::create_resources {
    ['config::fragment','listen','let','streams','stream','stream::publish','subscribe']:
  }
}
  
define riemann::hiera::create_resources {
  $rsname = "riemann::${title}"
  $varname = "${hiera_prefix}${rsname}"
  $hash_resources = hiera_hash($varname, {})
  validate_hash($hash_resources)
  create_resources($rsname, $hash_resources)
}
