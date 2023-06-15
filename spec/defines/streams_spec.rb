# frozen_string_literal: true

require 'spec_helper'

describe 'riemann::streams' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'without any parameters' do
        let(:params) { {} }

        describe 'with default title' do
          let :title do
            'default'
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_riemann__config__fragment('streams default header') }
          it { is_expected.to contain_riemann__config__fragment('streams default footer') }
        end

        describe 'with "custom" title' do
          let :title do
            'custom'
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_riemann__config__fragment('streams custom header') }
          it { is_expected.to contain_riemann__config__fragment('streams custom footer') }
        end
      end
    end
  end
end

# vim: ft=ruby
