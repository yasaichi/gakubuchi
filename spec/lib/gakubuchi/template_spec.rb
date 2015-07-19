require 'rails_helper'

RSpec.describe Gakubuchi::Template do
  let(:template_root) { described_class.root }
  let(:template) { Gakubuchi::Template.new(path) }

  describe '.all' do
    subject { described_class.all }
    it { is_expected.to be_all { |obj| obj.kind_of?(described_class) } }
  end

  describe '.root' do
    subject { described_class.root }
    it { is_expected.to eq Rails.root.join(Gakubuchi.configuration.template_root) }
  end

  describe '#basenanme' do
    subject { template.basename }
    let(:path) { template_root.join('foo.html.erb').to_s }

    it { is_expected.to eq 'foo.html.erb' }
  end

  describe '#compiled_pathname' do
    subject { template.compiled_pathname }
    let(:path) { template_root.join('foo/bar.html.erb').to_s }

    it { is_expected.to eq Rails.public_path.join('assets/foo/bar-*.{html,html.gz}') }
  end

  describe '#destination_pathname' do
    subject { template.destination_pathname }
    let(:path) { template_root.join('foo/bar.html.erb').to_s }

    it { is_expected.to eq Rails.public_path.join('foo/bar.html') }
  end

  describe '#extnanme' do
    subject { template.extname }
    let(:path) { template_root.join('foo.html.erb').to_s }

    it { is_expected.to eq '.html.erb' }
  end

  describe '#pathname' do
    subject { template.pathname }
    let(:path) { template_root.join('foo', 'bar.html.erb').to_s }

    it { is_expected.to eq Pathname.new(path) }
  end

  describe '#relative_pathname' do
    subject { template.relative_pathname }
    let(:path) { template_root.join('foo', 'bar.html.erb').to_s }

    it { is_expected.to eq Pathname.new('foo/bar.html.erb') }
  end
end
