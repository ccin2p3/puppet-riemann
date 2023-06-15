case $facts.get('os.family') {
  debian: {
    package { 'openjdk-11-jre-headless':
      ensure => installed,
    }

    file { '/tmp/riemann_0.3.8_all.deb':
      ensure => file,
      source => 'https://github.com/riemann/riemann/releases/download/0.3.8/riemann_0.3.8_all.deb',
    }

    package { 'riemann':
      ensure   => installed,
      provider => 'dpkg',
      source   => '/tmp/riemann_0.3.8_all.deb',
    }
  }
  default: {
    fail('The test suite assume riemann is available in the package manager')
  }
}
