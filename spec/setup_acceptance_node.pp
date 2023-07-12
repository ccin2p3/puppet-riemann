case $facts.get('os.family') {
  'Debian': {
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
  'RedHat': {
    package { 'java-1.8.0-openjdk-headless':
      ensure => installed,
    }

    file { '/tmp/riemann-0.3.8.rpm':
      ensure => file,
      source => "https://github.com/riemann/riemann/releases/download/0.3.8/riemann-0.3.8-1.noarch-EL${fact('os.distro.release.major')}.rpm",
    }

    package { 'riemann':
      ensure   => installed,
      provider => 'rpm',
      source   => '/tmp/riemann-0.3.8.rpm',
    }
  }
  default: {
    fail('The test suite assume riemann is available in the package manager')
  }
}
