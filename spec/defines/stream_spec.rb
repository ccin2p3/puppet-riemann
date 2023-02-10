# frozen_string_literal: true

require 'spec_helper'

describe 'riemann::stream' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with title=mytitle' do
        let :title do
          'mytitle'
        end

        describe 'without any parameters' do
          let(:params) { {} }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_riemann__streams('default') }
          it { is_expected.to contain_riemann__config__fragment('stream mytitle') }
        end
      end
    end
  end
end

# vim: ft=ruby
