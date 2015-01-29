require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann::foo' do
  context 'supported operating systems' do
    os_fixtures.each do |osname, osfixtures|
      describe "without any parameters" do
        let(:params) {{ }}
        describe "on #{osname}" do
          let(:facts) do
            osfixtures[:facts]
          end
          it { should compile.with_all_deps }
          it { should contain_class('riemann::foo') }
          it { should contain_class('riemann::foo::params') }
          it { should contain_class('riemann::foo::config') }
          it { should contain_class('riemann::foo::install').that_comes_before('riemann::foo::config') }
          it { should contain_class('riemann::foo::service').that_subscribes_to('riemann::foo::config') }
        end
      end
    end
  end
end

# vim: ft=ruby
