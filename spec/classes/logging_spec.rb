require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann::logging' do
  context 'supported operating systems' do
    os_fixtures.each do |osname, osfixtures|
      describe 'without any parameters' do
        let(:params) { {} }

        describe "on #{osname}" do
          let(:facts) do
            osfixtures[:facts]
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_riemann__config__fragment('riemann::logging').with_content(%r{logging\/init}) }
        end
      end
    end
  end
end

# vim: ft=ruby
