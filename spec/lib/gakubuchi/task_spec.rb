require "rails_helper"

RSpec.describe Gakubuchi::Task do
  describe "#execute!" do
    subject { -> { task.execute! } }

    let(:destination_path) { template.destination_path }
    let(:task) { described_class.new(template) }
    let(:template) { Gakubuchi::Template.new(source_path) }

    context "when template does not exist in specified source path" do
      let(:source_path) { "not_exist.html.erb" }

      it "has no side effects" do
        expect(&subject).not_to output.to_stdout
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
        File.write("#{digest_path}.gz", "")
      end

      context "when config.leave_digest_named_templates is true" do
        let(:config_value) { true }
        let(:expected_log_messeage) do
          /\A.*Copied #{digest_path} to #{destination_path}\Z/
        end

        it "generates the non-digest-named copies" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq true
          expect(File.exist?("#{digest_path}.gz")).to eq true
        end
      end

      context "when config.leave_digest_named_templates is false" do
        let(:config_value) { false }
        let(:expected_log_messeage) do
          /\A
            .*Copied\ #{digest_path}\ to\ #{destination_path}\n
            .*Removed\ #{digest_path}\ #{digest_path}.gz
          \Z/mx
        end

        it "generates the non-digest-named copies, and then removes the sources" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq false
          expect(File.exist?("#{digest_path}.gz")).to eq false
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
