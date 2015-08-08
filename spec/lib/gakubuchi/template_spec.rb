require 'rails_helper'

RSpec.describe Gakubuchi::Template do
  let(:template_root) { described_class.root }
  let(:template) { described_class.new(path) }

  describe '.all' do
    subject { described_class.all }

    let(:expectation) do
      [
        described_class.new(described_class.root.join('foo.html.erb')),
        described_class.new(described_class.root.join('bar/baz.html.erb')),
        described_class.new(described_class.root.join('qux.html.haml')),
        described_class.new(described_class.root.join('quux.html.slim'))
      ]
    end

    it { is_expected.to contain_exactly *expectation }
  end

  describe '.root' do
    subject { described_class.root }
    it { is_expected.to eq Rails.root.join(Gakubuchi.configuration.template_root) }
  end

  %w(== === eql?).each do |method_name|
    describe "##{method_name}" do
      subject { template.__send__(method_name, other) }
      let(:path) { template_root.join('foo.html.erb').to_s }

      context "other isn't a instance of Gakubuchi::Template" do
        let(:other) { path }
        it { is_expected.to eq false }
      end

      context 'other is a instance of Gakubuchi::Template' do
        let(:other) { described_class.new(other_path) }

        context '#pathname is equal to other.pathname' do
          let(:other_path) { path }
          it { is_expected.to eq true }
        end

        context "#pathname isn't equal to other.pathname" do
          let(:other_path) { template_root.join('foo/bar.html.erb').to_s }
          it { is_expected.to eq false }
        end
      end
    end
  end

  describe '#basenanme' do
    subject { template.basename }
    let(:path) { template_root.join('foo.html.erb').to_s }

    it { is_expected.to eq 'foo.html.erb' }
  end

  describe '#destination_pathname' do
    subject { template.destination_pathname }
    let(:path) { template_root.join('bar/baz.html.erb').to_s }

    it { is_expected.to eq Rails.public_path.join('bar/baz.html') }
  end

  describe '#extnanme' do
    subject { template.extname }
    let(:path) { template_root.join('foo.html.erb').to_s }

    it { is_expected.to eq '.html.erb' }
  end

  describe '#pathname' do
    subject { template.pathname }
    let(:path) { template_root.join('foo/bar.html.erb').to_s }

    it { is_expected.to eq Pathname.new(path) }
  end

  describe '#precompiled_pathnames' do
    let(:path) { template_root.join('bar/baz.html.erb').to_s }
    let(:described_method) { -> { template.precompiled_pathnames } }

    describe 'return value' do
      subject { described_method.call }
      it { is_expected.to an_instance_of Array }
    end

    describe 'Pathname' do
      subject { Pathname }
      let(:expected_pathname) { Rails.public_path.join('assets/bar/baz-*.{html,html.gz}') }

      before do
        allow(subject).to receive(:glob)
        described_method.call
      end

      it { is_expected.to have_received(:glob).with(expected_pathname) }
    end
  end

  describe '#relative_pathname' do
    subject { template.relative_pathname }
    let(:path) { template_root.join('bar/baz.html.erb').to_s }

    it { is_expected.to eq Pathname.new('bar/baz.html.erb') }
  end
end
