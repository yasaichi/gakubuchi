require 'rails_helper'

RSpec.describe Gakubuchi do
  describe '.configuration' do
    subject { described_class.configuration }
    it { is_expected.to be_an_instance_of Gakubuchi::Configuration }
  end

  describe '.configure' do
    let(:template_directory) { 'foo' }
    let(:expected_attrs) do
      {
        remove_precompiled_templates: false,
        template_directory: template_directory
      }
    end

    subject { described_class.configuration }

    before do
      Gakubuchi.configure do |config|
        config.remove_precompiled_templates = false
        config.template_directory = template_directory
      end
    end

    it { is_expected.to have_attributes(expected_attrs) }

    after do
      Gakubuchi.configuration = Gakubuchi::Configuration.new
    end
  end
end
