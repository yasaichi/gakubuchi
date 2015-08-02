require 'rails_helper'

RSpec.describe Gakubuchi::Task do
  let(:task) { described_class.new(templates) }

  describe '#execute!' do
    let(:templates) { [template] }
    let(:src) { double(:pathname, extname: '.html', mtime: 3) }

    let(:precompiled_pathnames) do
      [
        src,
        double(:pathname, extname: '.html.gz', mtime: 1),
        double(:pathname, extname: '.html', mtime: 2),
        double(:pathname, extname: '.html.gz', mtime: 4),
      ]
    end

    let(:template) do
      path = Gakubuchi::Template.root.join('foo.html.erb').to_s

      Gakubuchi::Template.new(path).tap do |template|
        allow(template).to receive(:precompiled_pathnames).and_return(precompiled_pathnames)
      end
    end

    describe 'Gakubuchi::FileUtils' do
      subject { Gakubuchi::FileUtils }

      before do
        allow(subject).to receive(:copy_p)
        allow(subject).to receive(:remove)
      end

      describe '.copy_p' do
        let(:dest) { template.destination_pathname }

        before do
          task.execute!
        end

        it { is_expected.to have_received(:copy_p).with(src, dest) }
      end

      describe '.remove' do
        before do
          allow(task).to receive(:remove_precompiled_templates?).and_return(return_value)
          task.execute!
        end

        context '#remove_precompiled_templates? returns true' do
          let(:return_value) { true }
          it { is_expected.to have_received(:remove).with(precompiled_pathnames) }
        end

        context '#remove_precompiled_templates? returns false' do
          let(:return_value) { false }
          it { is_expected.not_to have_received(:remove) }
        end
      end
    end
  end

  describe '#remove_precompiled_templates?' do
    subject { task.remove_precompiled_templates? }
    let(:templates) { [] }

    before do
      Gakubuchi.configuration.remove_precompiled_templates = config_value
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
