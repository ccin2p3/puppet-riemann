# frozen_string_literal: true

require 'spec_helper'

os_fixtures = @os_fixtures

describe 'riemann::logging' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'without any parameters' do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_riemann__config__fragment('riemann::logging').with_content(%r{logging/init}) }
      end
    end
  end
end

# vim: ft=ruby
