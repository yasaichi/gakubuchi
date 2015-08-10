require 'rails_helper'

RSpec.describe Gakubuchi::Configuration do
  let(:configuration) { described_class.new }

  describe '#to_h' do
    subject { configuration.to_h }
    it { is_expected.to be_an_instance_of Hash }
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

  describe '#template_directory' do
    subject { configuration.template_directory }

    context 'a value was set by the attr_writer' do
      before do
        configuration.template_directory = 'foo'
      end

      it { is_expected.to eq 'foo' }
    end

    context 'a value was not set by the attr_writer' do
      it { is_expected.to eq 'templates' }
    end
  end
end
