#
define riemann::hiera::create_resources {
  $rsname = "riemann::${title}"
  $varname = "${riemann::hiera::prefix}${rsname}"
  create_resources (
    $rsname,
    lookup(
      $varname,
      { default_value => {} }
    )
  )
}
