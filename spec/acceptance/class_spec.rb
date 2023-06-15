# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'riemann class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'riemann': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('riemann') do
      it { is_expected.to be_installed }
    end

    describe service('riemann') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
