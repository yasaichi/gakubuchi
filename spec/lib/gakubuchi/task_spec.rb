require 'rails_helper'

RSpec.describe Gakubuchi::Task do
  let(:task) { described_class.new(templates) }

  describe '#execute!' do
    let(:templates) { [template] }

    let(:template) do
      Gakubuchi::Template.new('foo.html.erb').tap do |template|
        allow(template).to receive(:digest_path).and_return(digest_path)
      end
    end

    describe 'Gakubuchi::FileUtils' do
      subject { Gakubuchi::FileUtils }

      before do
        allow(subject).to receive(:copy_p)
        allow(subject).to receive(:remove)
      end

      context 'when digest path is nil' do
        let(:digest_path) { nil }

        before do
          task.execute!
        end

        describe '.copy_p' do
          it { is_expected.not_to have_received(:copy_p) }
        end

        describe '.remove' do
          it { is_expected.not_to have_received(:remove) }
        end
      end

      context 'when digest path is not nil' do
        let(:digest_path) { double(:pathname) }

        describe '.copy_p' do
          let(:dest) { template.destination_path }

          before do
            task.execute!
          end

          it { is_expected.to have_received(:copy_p).with(digest_path, dest) }
        end

        describe '.remove' do
          before do
            allow(task).to receive(:leave_digest_named_templates?).and_return(return_value)
            task.execute!
          end

          context 'when #leave_digest_named_templates? returns true' do
            let(:return_value) { true }
            it { is_expected.not_to have_received(:remove) }
          end

          context 'when #leave_digest_named_templates? returns false' do
            let(:return_value) { false }
            it { is_expected.to have_received(:remove).with(digest_path) }
          end
        end
      end
    end
  end

  describe '#leave_digest_named_templates?' do
    subject { task.leave_digest_named_templates? }
    let(:templates) { [] }

    before do
      Gakubuchi.configuration.leave_digest_named_templates = config_value
    end

    context 'when the configuration value is evaluated as true' do
      let(:config_value) { 1 }
      it { is_expected.to eq true }
    end

    context 'when the configuration value is evaluated as false' do
      let(:config_value) { nil }
      it { is_expected.to eq false }
    end

    after do
      Gakubuchi.reset
    end
  end
end
