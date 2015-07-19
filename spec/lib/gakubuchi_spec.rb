require 'rails_helper'

RSpec.describe Gakubuchi do
  describe '.configuration' do
    subject { described_class.configuration }
    it { is_expected.to be_a_instance_of(Gakubuchi::Configuration) }
  end

  describe '.configure' do
    let(:template_root) { 'app/assets/foo' }
    let(:expected_attrs) do
      { template_root: template_root }
    end

    subject { described_class.configuration }

    before do
      Gakubuchi.configure do |config|
        config.template_root = template_root
      end
    end

    it { is_expected.to have_attributes(expected_attrs) }
  end
end
