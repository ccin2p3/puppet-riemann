# frozen_string_literal: true

require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'without any parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('riemann') }
        it { is_expected.to contain_class('riemann::config') }
        it { is_expected.to contain_class('riemann::install').that_comes_before('Class[riemann::config]') }
        it { is_expected.to contain_class('riemann::service').that_subscribes_to('Class[riemann::config]') }
      end

      describe 'with init_defaults' do
        let(:params) do
          {
            manage_init_defaults: true,
            init_config_file: '/path/to/config'
          }
        end

        it { is_expected.to contain_file('/path/to/config') }
      end
    end
  end

  context 'on unsupported operating system' do
    describe 'without any parameters' do
      let(:params) { {} }

      describe 'on AmigaOS' do
        let(:facts) do
          {
            osfamily: 'Commodore',
            operatingsystem: 'AmigaOS',
          }
        end

        it { expect { is_expected.to contain_class('riemann') }.to raise_error(Puppet::Error) }
      end

      describe 'on Scientific Linux 5' do
        let(:facts) do
          {
            osfamily: 'RedHat',
            operatingsystem: 'Scientific',
            operatingsystemmajrelease: 5,
          }
        end

        it { expect { is_expected.to contain_class('riemann') }.to raise_error(Puppet::Error) }
      end
    end
  end
end

# vim: ft=ruby
