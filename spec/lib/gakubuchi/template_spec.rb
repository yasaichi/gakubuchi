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

    it { is_expected.to match_array(expectation) }
  end

  describe '.root' do
    subject { described_class.root }
    it { is_expected.to eq Rails.root.join('app/assets', Gakubuchi.configuration.template_directory) }
  end

  %w(== === eql?).each do |method_name|
    describe "##{method_name}" do
      subject { template.__send__(method_name, other) }
      let(:path) { template_root.join('foo.html.erb').to_s }

      context 'when other is not an instance of Gakubuchi::Template' do
        let(:other) { path }
        it { is_expected.to eq false }
      end

      context 'when other is an instance of Gakubuchi::Template' do
        let(:other) { described_class.new(other_path) }

        context 'when #pathname is equal to other.pathname' do
          let(:other_path) { path }
          it { is_expected.to eq true }
        end

        context 'when #pathname is not equal to other.pathname' do
          let(:other_path) { template_root.join('foo/bar.html.erb').to_s }
          it { is_expected.to eq false }
        end
      end
    end
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

  describe '#precompiled_pathname' do
    subject { template.precompiled_pathname }

    context 'when template does not exist in specified path' do
      let(:path) { template_root.join('not_exist.html.erb').to_s }
      it { is_expected.to eq nil }
    end

    context 'when template exists in the specified path' do
      let(:path) { template_root.join('bar/baz.html.erb').to_s }

      it 'should return a pathname which refers to the precompiled template' do
        expected_path = Rails.public_path.join('assets', 'bar/baz-[a-z0-9]+.html').to_s

        expect(subject).to be_an_instance_of Pathname
        expect(subject.to_s).to match Regexp.new(expected_path)
      end
    end
  end

  describe '#relative_pathname' do
    subject { template.relative_pathname }
    let(:path) { template_root.join('bar/baz.html.erb').to_s }

    it { is_expected.to eq Pathname.new('bar/baz.html.erb') }
  end
end
