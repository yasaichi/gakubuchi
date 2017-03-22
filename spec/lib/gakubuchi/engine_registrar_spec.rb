require "rails_helper"

RSpec.describe Gakubuchi::EngineRegistrar do
  let(:engine_registrar) { described_class.new(env) }
  let(:env) { Sprockets::Environment.new }

  describe "#register" do
    let(:described_method) { -> { engine_registrar.register(mime_type, engine) } }
    let(:mime_type) { Gakubuchi::MimeType.new(content_type, extensions: extensions) }
    let(:sprokcets_extensions) do
      extension_type = major_version_of(Sprockets) >= 4 ? :transformers : :engines
      -> { env.public_send(extension_type) }
    end

    context "when specified engine is an uninitialized constant" do
      let(:content_type) { "application/csv+ruby" }
      let(:engine) { "Foo" }
      let(:extensions) { %w(.rcsv .csv.rcsv) }

      it "should return false" do
        expect(described_method.call).to eq false
      end

      it "shouldn't register the engine for the MIME type" do
        expect(&described_method).not_to change(&sprokcets_extensions)
      end
    end

    context "when there is no extensions corresponding the MIME type" do
      let(:content_type) { "application/csv+ruby" }
      let(:engine) { Tilt::CSVTemplate }
      let(:extensions) { nil }

      it "should return false" do
        expect(described_method.call).to eq false
      end

      it "shouldn't register the engine for the MIME type" do
        expect(&described_method).not_to change(&sprokcets_extensions)
      end
    end

    context "when all parameters are valid" do
      let(:content_type) { "application/csv+ruby" }
      let(:engine) { Tilt::CSVTemplate }
      let(:extensions) { %w(.rcsv .csv.rcsv) }
      let(:extensions_with_single_dot) { extensions.select { |ext| ext =~ /\A\.[^\.]+\z/ } }

      it "should return true" do
        expect(described_method.call).to eq true
      end

      it "should register the engine for the MIME type" do
        diff =
          case major_version_of(Sprockets)
          when 2
            Hash[extensions_with_single_dot.map { |ext| [ext, engine] }]
          when 3
            Hash[extensions_with_single_dot.map { |ext| [ext, an_object_responding_to(:call)] }]
          when 4..Float::INFINITY
            { content_type => { engine.default_mime_type => an_object_responding_to(:call) } }
          end

        expect(&described_method).to change(&sprokcets_extensions).to(hash_including(diff))
      end
    end
  end
end
