require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann::stream' do
  context 'supported operating systems' do
    os_fixtures.each do |osname, osfixtures|
      describe 'with title=mytitle' do
        let :title do
          'mytitle'
        end

        describe 'without any parameters' do
          let(:params) { {} }

          describe "on #{osname}" do
            let(:facts) do
              osfixtures[:facts]
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_riemann__streams('default') }
            it { is_expected.to contain_riemann__config__fragment('stream mytitle') }
          end
        end
      end
    end
  end
end

# vim: ft=ruby
