require "rails_helper"

RSpec.describe Gakubuchi::Task do
  let(:task) { described_class.new(Gakubuchi::Configuration.new) }

  describe "#publish" do
    subject { -> { task.publish(template) } }

    let(:destination_path) { template.destination_path }
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
        task.configuration.leave_digest_named_templates = config_value

        FileUtils.mkdir_p(digest_path.dirname)
        File.write(digest_path, "")
        File.write("#{digest_path}.gz", "")
      end

      context "when #configuration.leave_digest_named_templates is true" do
        let(:config_value) { true }
        let(:expected_log_messeage) do
          /\A.*Copied #{digest_path} to #{destination_path}\Z/
        end

        it "generates the non-digest-named copy" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq true
          expect(File.exist?("#{digest_path}.gz")).to eq true
        end
      end

      context "when #configuration.leave_digest_named_templates is false" do
        let(:config_value) { false }
        let(:expected_log_messeage) do
          /\A
            .*Copied\ #{digest_path}\ to\ #{destination_path}\n
            .*Removed\ #{digest_path}\ #{digest_path}.gz
          \Z/mx
        end

        it "generates the non-digest-named copy, and then removes the source" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq true
          expect(File.exist?(digest_path)).to eq false
          expect(File.exist?("#{digest_path}.gz")).to eq false
        end
      end

      after do
        FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
      end
    end
  end

  describe "#remove" do
    subject { -> { task.remove(template) } }

    let(:destination_path) { template.destination_path }
    let(:template) { Gakubuchi::Template.new(source_path) }

    context "when non-digest-named copy does not exist" do
      let(:source_path) { "not_exist.html.erb" }

      it "has no side effects" do
        expect(&subject).not_to output.to_stdout
        expect(File.exist?(destination_path)).to eq false
      end
    end

    context "when non-digest-named copy exists" do
      before do
        FileUtils.mkdir_p(destination_path.dirname)
        File.write(destination_path, "")
      end

      context "in Rails.public_path" do
        let(:source_path) { "foo.html.erb" }
        let(:expected_log_messeage) { /\A.*Removed #{destination_path}\Z/ }

        it "removes the copy" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq false
          expect(File.exist?(destination_path.dirname)).to eq true
        end
      end

      context "in a directroy of Rails.public_path" do
        let(:source_path) { "bar/baz.html.erb" }
        let(:expected_log_messeage) do
          /\A
            .*Removed\ #{destination_path}\n
            .*Removed\ #{destination_path.dirname}
          \Z/mx
        end

        it "removes the copy and the directroy" do
          expect(&subject).to output(expected_log_messeage).to_stdout

          expect(File.exist?(destination_path)).to eq false
          expect(File.exist?(destination_path.dirname)).to eq false
        end
      end
    end
  end
end
