require "rails_helper"

RSpec.describe Gakubuchi::Task do
  let(:task) { described_class.new(templates) }

  describe "#execute!" do
    let(:templates) { [template] }
    let(:template) { Gakubuchi::Template.new(source_path) }

    describe "Gakubuchi::FileUtils" do
      subject { Gakubuchi::FileUtils }

      before do
        allow(subject).to receive(:copy_p)
        allow(subject).to receive(:remove)
      end

      context "when template does not exist in specified source path" do
        let(:source_path) { "not_exist.html.erb" }

        before do
          task.execute!
        end

        describe ".copy_p" do
          it { is_expected.not_to have_received(:copy_p) }
        end

        describe ".remove" do
          it { is_expected.not_to have_received(:remove) }
        end
      end

      context "when template exists in specified source path" do
        let(:source_path) { "foo.html.erb" }

        describe ".copy_p" do
          before do
            allow(task).to receive(:copy_templates_to_public?).and_return(return_value)
            task.execute!
          end

          context "when #copy_templates_to_public? returns true" do
            let(:return_value) { true }
            let(:expectation) { [template.digest_path, template.destination_path] }

            it { is_expected.to have_received(:copy_p).with(*expectation) }
          end

          context "when #copy_templates_to_public? returns false" do
            let(:return_value) { false }
            it { is_expected.not_to have_received(:copy_p) }
          end
        end

        describe ".remove" do
          before do
            allow(task).to receive(:leave_digest_named_templates?).and_return(return_value)
            task.execute!
          end

          context "when #leave_digest_named_templates? returns true" do
            let(:return_value) { true }
            it { is_expected.not_to have_received(:remove) }
          end

          context "when #leave_digest_named_templates? returns false" do
            let(:return_value) { false }
            let(:expectation) { a_collection_including(template.digest_path) }

            it { is_expected.to have_received(:remove).with(expectation) }
          end
        end
      end
    end
  end

  describe "#leave_digest_named_templates?" do
    subject { task.leave_digest_named_templates? }
    let(:templates) { [] }

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
end
