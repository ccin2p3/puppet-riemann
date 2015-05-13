class {'riemann':
  config_dir           => '/tmp/riemann',
  manage_init_defaults => true,
  init_config_file     => '/tmp/riemann/initdefaults',
  init_config_hash     => {
    'EXTRA_JAVA_OPTS'  => '"-Dcom.sun.management.jmxremote.port=17264 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote"'
  }
}

