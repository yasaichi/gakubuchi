require "rails_helper"

RSpec.describe Gakubuchi::Task do
  describe "#execute!" do
    let(:destination_path) { template.destination_path }
    let(:task) { described_class.new(template) }
    let(:template) { Gakubuchi::Template.new(source_path) }

    context "when template does not exist in specified source path" do
      let(:source_path) { "not_exist.html.erb" }

      before do
        task.execute!
      end

      it "has no side effects" do
        expect(File.exist?(destination_path)).to eq false
      end
    end

    context "when template exists in specified source path" do
      let(:source_path) { "bar/baz.html.erb" }
      let(:digest_path) { template.digest_path }

      before do
        Gakubuchi.configuration.leave_digest_named_templates = config_value

        FileUtils.mkdir_p(digest_path.dirname)
        File.write(digest_path, "")

        task.execute!
      end

      context "when config.leave_digest_named_templates is true" do
        let(:config_value) { true }

        # TODO: Test the log messages
        it "generates the non-digest-named copies" do
          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq true
        end
      end

      context "when config.leave_digest_named_templates is false" do
        let(:config_value) { false }

        it "generates the non-digest-named copies, and then removes the sources" do
          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq false
        end
      end

      after do
        FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
        Gakubuchi.reset
      end
    end
  end

  describe "#leave_digest_named_templates?" do
    subject { task.leave_digest_named_templates? }
    let(:task) { described_class.new([]) }

    before do
      Gakubuchi.configuration.leave_digest_named_templates = config_value
    end

    context "when the configuration value is evaluated as true" do
      let(:config_value) { 1 }
      it { is_expected.to eq true }
    end

    context "when the configuration value is evaluated as false" do
      let(:config_value) { nil }
      it { is_expected.to eq false }
    end

    after do
      Gakubuchi.reset
    end
  end

  describe "#templates" do
    subject { described_class.new(argument).templates }

    context "when one template is passed into .new" do
      let(:argument) { Gakubuchi::Template.new("foo.html.erb") }
      it { is_expected.to eq [argument] }
    end

    context "when an array of templates is passed into .new" do
      let(:argument) { [Gakubuchi::Template.new("foo.html.erb")] }
      it { is_expected.to eq argument }
    end
  end
end
