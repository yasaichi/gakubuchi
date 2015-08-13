require 'rails_helper'

RSpec.describe Gakubuchi::TemplateEngine do
  let(:assets) { Rails.application.assets }
  let(:template_engine) { described_class.new(engine) }

  %w(engine klass).each do |described_method|
    describe "##{described_method}" do
      subject { template_engine.public_send(described_method) }

      context 'specified engine is uninitialized' do
        let(:engine) { 'Foo' }
        it { is_expected.to eq nil }
      end

      context 'specified engine is initialized' do
        let(:engine) { 'Sprockets::ERBProcessor' }
        it { is_expected.to eq Sprockets::ERBProcessor }
      end
    end
  end

  describe '#register!' do
    subject { template_engine.register!(extname) }

    context "#engine isn't a class" do
      let(:engine) { 'Foo' }
      let(:extname) { '.erb' }

      it { is_expected.to eq false }
    end

    context '#engine is already registered for specified extname' do
      let(:engine) { Sprockets::ERBProcessor }
      let(:extname) { '.erb' }

      it { is_expected.to eq false }
    end

    context "#engine is not yet registered for specified extname" do
      let(:engine) { Sprockets::ERBProcessor }
      let(:extname) { '.foo' }

      before do
        allow(assets).to receive(:register_engine).and_return({})
      end

      it 'should call register_engine() 1 time and return true' do
        expect(subject).to eq true
        expect(assets).to have_received(:register_engine).with(extname, engine)
      end
    end
  end

  describe '#registered?' do
    subject { template_engine.registered?(extname) }

    context '#engine is already registered for specified extname' do
      let(:engine) { Sprockets::ERBProcessor }
      let(:extname) { '.erb' }

      it { is_expected.to eq true }
    end

    context "#engine is not yet registered for specified extname" do
      let(:engine) { Sprockets::ERBProcessor }
      let(:extname) { '.foo' }

      it { is_expected.to eq false }
    end
  end
end
