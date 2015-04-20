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
  create_resources (
    $rsname,
    hiera_hash(
      $varname,
      {}
    )
  )
}
