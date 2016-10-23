require "rails_helper"

RSpec.describe Gakubuchi::Configuration do
  let(:configuration) { described_class.new }

  describe "#to_h" do
    subject { configuration.to_h }
    it { is_expected.to be_an_instance_of Hash }
  end

  describe "#leave_digest_named_templates" do
    subject { configuration.leave_digest_named_templates }

    context "when a value was set by the attr_writer" do
      before do
        configuration.leave_digest_named_templates = true
      end

      it { is_expected.to eq true }
    end

    context "when a value was not set by the attr_writer" do
      it { is_expected.to eq false }
    end
  end

  describe "#template_directory" do
    subject { configuration.template_directory }

    context "when a value was set by the attr_writer" do
      before do
        configuration.template_directory = "foo"
      end

      it { is_expected.to eq "foo" }
    end

    context "when a value was not set by the attr_writer" do
      it { is_expected.to eq "templates" }
    end
  end
end
