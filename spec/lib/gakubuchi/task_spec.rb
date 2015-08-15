require 'rails_helper'

RSpec.describe Gakubuchi::Task do
  let(:task) { described_class.new(templates) }

  describe '#execute!' do
    let(:templates) { [template] }

    let(:template) do
      path = Gakubuchi::Template.root.join('foo.html.erb').to_s

      Gakubuchi::Template.new(path).tap do |template|
        allow(template).to receive(:precompiled_pathname).and_return(precompiled_pathname)
      end
    end

    describe 'Gakubuchi::FileUtils' do
      subject { Gakubuchi::FileUtils }

      before do
        allow(subject).to receive(:copy_p)
        allow(subject).to receive(:remove)
      end

      context 'precompiled pathname is nil' do
        let(:precompiled_pathname) { nil }

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

      context 'precompiled pathname is not nil' do
        let(:precompiled_pathname) { double(:pathname) }

        describe '.copy_p' do
          let(:dest) { template.destination_pathname }

          before do
            task.execute!
          end

          it { is_expected.to have_received(:copy_p).with(precompiled_pathname, dest) }
        end

        describe '.remove' do
          before do
            allow(task).to receive(:leave_digest_named_templates?).and_return(return_value)
            task.execute!
          end

          context '#leave_digest_named_templates? returns true' do
            let(:return_value) { true }
            it { is_expected.not_to have_received(:remove) }
          end

          context '#leave_digest_named_templates? returns false' do
            let(:return_value) { false }
            it { is_expected.to have_received(:remove).with(precompiled_pathname) }
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

    context 'the configuration value is evaluated as true' do
      let(:config_value) { 1 }
      it { is_expected.to eq true }
    end

    context 'the configuration value is evaluated as false' do
      let(:config_value) { nil }
      it { is_expected.to eq false }
    end

    after do
      Gakubuchi.configuration = Gakubuchi::Configuration.new
    end
  end
end
