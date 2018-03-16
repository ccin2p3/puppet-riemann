require 'puppetlabs_spec_helper/module_spec_helper'

# common facts to all supported OS
# e.g. mocking concat_basedir can be handy

RSpec.configure do |c|
  c.default_facts = {
    concat_basedir: '/DIR',
  }
end

# specific facts per supported OS
#

@os_fixtures = {
  'EL6' => {
    facts: {
      operatingsystem: 'Scientific',
      osfamily: 'RedHat',
      operatingsystemmajrelease: 6,
      os: { family: 'RedHat', release: { major: 6 } },
    },
    params: {
      package_name: 'riemann',
      service_name: 'riemann',
      config_dir: '/etc/riemann',
      init_config_file: '/etc/sysconfig/riemann',
      reload_command: '/sbin/service riemann reload',
      log_file: '/var/log/riemann/riemann.log'
    }
  },
  'EL7' => {
    facts: {
      operatingsystem: 'CentOS',
      osfamily: 'RedHat',
      operatingsystemmajrelease: 7,
      os: { family: 'RedHat', release: { major: 7 } },
    },
    params: {
      package_name: 'riemann',
      service_name: 'riemann',
      config_dir: '/etc/riemann',
      init_config_file: '/etc/sysconfig/riemann',
      reload_command: 'kill -HUP $(</var/run/riemann.pid)',
      log_file: '/var/log/riemann/riemann.log'
    }
  },
  'Debian8' => {
    facts: {
      operatingsystem: 'Debian',
      osfamily: 'Debian',
      operatingsystemmajrelease: 8,
      os: { family: 'Debian', release: { major: 8 } },
    },
    params: {
      package_name: 'riemann',
      service_name: 'riemann',
      config_dir: '/etc/riemann',
      init_config_file: '/etc/default/riemann',
      reload_command: '/usr/sbin/service riemann reload',
      log_file: '/var/log/riemann/riemann.log'
    }
  },
}

# add other combinations if you want to support a new OS e.g.
#
# 'MyOS-42' => @common_facts.merge({
#    :operatingsystem => 'OpenSolaris',
#    :osfamily => 'Solaris',
#    :operatingsystemmajrelease => 12
#  })

# If you want to fetch all values from hiera
#  e.g. because you're testing code that uses explicit hiera lookups
#
#RSpec.configure do |c|
#  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
#end
