require "rails_helper"

RSpec.describe Gakubuchi::EngineRegistrar do
  let(:env) { Sprockets::Environment.new }
  let(:engine_registrar) { described_class.new(env) }

  describe "#register" do
    let(:described_method) { -> { engine_registrar.register(target, engine) } }

    context "when specified engine is an uninitialized constant" do
      let(:target) { :foo }
      let(:engine) { "Foo" }

      describe "env.engines" do
        subject { -> { env.engines } }
        it { expect(&described_method).not_to change(&subject) }
      end

      describe "return value" do
        subject { described_method.call }
        it { is_expected.to eq false }
      end
    end

    context "when specified target is already registered" do
      let(:target) { :sass }
      let(:engine) { "Sprockets::SassTemplate" }

      describe "env.engines" do
        subject { -> { env.engines } }
        it { expect(&described_method).not_to change(&subject) }
      end

      describe "return value" do
        subject { described_method.call }
        it { is_expected.to eq false }
      end
    end

    context "when specified target is not registered" do
      let(:target) { :foo }
      let(:engine) { "Sprockets::SassTemplate" }

      describe "env.engines" do
        subject { -> { env.engines } }
        let(:expectation) { a_hash_including(".foo" => Sprockets::SassTemplate) }

        it { expect(&described_method).to change(&subject).to(expectation) }
      end

      describe "return value" do
        subject { described_method.call }
        it { is_expected.to eq true }
      end
    end
  end

  describe "#registered?" do
    subject { engine_registrar.registered?(target) }

    context "when specified target is not registered" do
      let(:target) { :foo }
      it { is_expected.to eq false }
    end

    context "when specified target is already registered" do
      let(:target) { :erb }
      it { is_expected.to eq true }
    end
  end
end
