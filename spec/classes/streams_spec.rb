require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann::streams' do
  context 'supported operating systems' do
    os_fixtures.each do |osname, osfixtures|
      describe "without any parameters" do
        let(:params) {{ }}
        describe "on #{osname}" do
          let(:facts) do
            osfixtures[:facts]
          end
          it { should compile.with_all_deps }
          it { should contain_riemann__config__fragment('streams header') }
          it { should contain_riemann__config__fragment('streams footer') }
        end
      end
    end
  end
end

# vim: ft=ruby
