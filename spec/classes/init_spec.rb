require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann' do
  context 'supported operating systems' do
    os_fixtures.each do |osname, osfixtures|
      describe 'without any parameters' do
        let(:params) { {} }

        describe "on #{osname}" do
          let(:facts) do
            osfixtures[:facts]
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('riemann') }
          it { is_expected.to contain_class('riemann::config') }
          it { is_expected.to contain_class('riemann::install').that_comes_before('Class[riemann::config]') }
          it { is_expected.to contain_class('riemann::service').that_subscribes_to('Class[riemann::config]') }
        end
      end
      describe 'with init_defaults' do
        let(:facts) do
          osfixtures[:facts]
        end
        let(:params) do
          { manage_init_defaults: true }.merge(osfixtures[:params])
        end

        describe "on #{osname}" do
          let :init_config_file do
            osfixtures[:params][:init_config_file]
          end

          it { is_expected.to contain_file(init_config_file) }
        end
      end
    end
  end

  context 'unsupported operating system' do
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
