require 'rails_helper'

RSpec.describe Gakubuchi::Configuration do
  let(:configuration) { described_class.new }

  describe '#to_h' do
    subject { configuration.to_h }
    it { is_expected.to be_a_kind_of(Hash) }
  end

  describe '#remove_precompiled_templates' do
    subject { configuration.remove_precompiled_templates }

    context 'a value was set by the attr_writer' do
      before do
        configuration.remove_precompiled_templates = false
      end

      it { is_expected.to eq false }
    end

    context 'a value was not set by the attr_writer' do
      it { is_expected.to eq true }
    end
  end

  describe '#template_root' do
    subject { configuration.template_root }

    context 'a value was set by the attr_writer' do
      before do
        configuration.template_root = 'app/assets/foo'
      end

      it { is_expected.to eq 'app/assets/foo' }
    end

    context 'a value was not set by the attr_writer' do
      it { is_expected.to eq 'app/assets/templates' }
    end
  end
end
