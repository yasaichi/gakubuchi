require "rails_helper"

RSpec.describe Gakubuchi::MimeType do
  describe "#new" do
    subject { -> { described_class.new(content_type) } }

    context "when an invalid `content_type` is specified" do
      let(:content_type) { "foo" }
      it { is_expected.to raise_error(Gakubuchi::Error::InvalidMimeType, /#{content_type}/) }
    end

    context "when a valid `content_type` is specified" do
      let(:content_type) { "application/csv+ruby" }
      it { is_expected.not_to raise_error }
    end
  end

  describe "#content_type" do
    subject { described_class.new(content_type).content_type }
    let(:content_type) { "application/csv+ruby" }

    it { is_expected.to eq content_type }
  end

  describe "#extensions" do
    subject { described_class.new("application/csv+ruby", options).extensions }

    context "when `extensions` isn't specified" do
      let(:options) { { extensions: nil } }

      it { is_expected.to be_an_instance_of(Array) }
      it { is_expected.to be_empty }
    end

    context "when `extensions` includes duplicated values" do
      let(:options) { { extensions: %w(.rcsv .csv.ruby .rcsv) } }

      it { is_expected.to be_an_instance_of(Array) }
      it { is_expected.to contain_exactly(*options[:extensions].uniq) }
    end

    context "when `extensions` includes non-string values" do
      let(:options) { { extensions: %i(.rcsv .csv.ruby) } }

      it { is_expected.to be_an_instance_of(Array) }
      it { is_expected.to contain_exactly(*options[:extensions].map(&:to_s)) }
    end
  end
end
