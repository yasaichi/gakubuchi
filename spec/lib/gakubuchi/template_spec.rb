require "rails_helper"

RSpec.describe Gakubuchi::Template do
  let(:template) { described_class.new(source_path) }
  let(:template_root) { described_class.root }

  describe ".all" do
    subject { described_class.all }

    let(:expectation) do
      [
        described_class.new("foo.html.erb"),
        described_class.new("bar/baz.html.erb"),
        described_class.new("qux.html.haml"),
        described_class.new("quux.html.slim")
      ]
    end

    it { is_expected.to match_array(expectation) }
  end

  describe ".new" do
    subject { -> { described_class.new(source_path) } }

    context "when source path does not refer to a template file" do
      let(:source_path) { "foo.txt" }
      let(:error_message) { "source path must refer to a template file" }

      it { is_expected.to raise_error(Gakubuchi::Error::InvalidTemplate, error_message) }
    end

    context "when source path refers to a template file" do
      context "when tha path is relative" do
        let(:source_path) { "foo.html.erb" }
        it { is_expected.not_to raise_error }
      end

      context "when the path is absolute and begins with #{described_class}.root" do
        let(:source_path) { template_root.join("foo.html.erb") }
        it { is_expected.not_to raise_error }
      end

      context "when the path is absolute but does not begin with #{described_class}.root" do
        let(:source_path) { "/foo.html.erb" }
        let(:error_message) { "template must exist in #{described_class.root}" }

        it { is_expected.to raise_error(Gakubuchi::Error::InvalidTemplate, error_message) }
      end
    end
  end

  describe ".root" do
    subject { described_class.root }
    it { is_expected.to eq Rails.root.join("app/assets", Gakubuchi.configuration.template_directory) }
  end

  %w(== === eql?).each do |method_name|
    describe "##{method_name}" do
      subject { template.__send__(method_name, other) }
      let(:source_path) { "foo.html.erb" }

      context "when other is not an instance of Gakubuchi::Template" do
        let(:other) { source_path }
        it { is_expected.to eq false }
      end

      context "when other is an instance of Gakubuchi::Template" do
        let(:other) { described_class.new(other_source_path) }

        context "when #source_path is equal to other.source_path" do
          let(:other_source_path) { source_path }
          it { is_expected.to eq true }
        end

        context "when #source_path is not equal to other.source_path" do
          let(:other_source_path) { "bar/baz.html.erb" }
          it { is_expected.to eq false }
        end
      end
    end
  end

  describe "#destination_path" do
    subject { template.destination_path }
    let(:source_path) { "bar/baz.html.erb" }

    it { is_expected.to eq Rails.public_path.join("bar/baz.html") }
  end

  describe "#digest_path" do
    subject { template.digest_path }

    context "when template does not exist in specified source path" do
      let(:source_path) { "not_exist.html.erb" }
      it { is_expected.to eq nil }
    end

    context "when template exists in specified source path" do
      let(:source_path) { "bar/baz.html.erb" }
      let(:expectation) { Rails.public_path.join("assets", "bar/baz-[a-z0-9]*.html").to_s }

      it { is_expected.to be_an_instance_of Pathname }
      it { is_expected.to be_fnmatch(expectation) }
    end
  end

  describe "#extnanme" do
    subject { template.extname }
    let(:source_path) { "foo.html.erb" }

    it { is_expected.to eq ".html.erb" }
  end

  describe "#logical_path" do
    subject { template.logical_path }
    let(:source_path) { "bar/baz.html.erb" }

    it { is_expected.to eq Pathname.new("bar/baz.html") }
  end

  describe "#source_path" do
    subject { template.source_path }

    context "when specified source path is relative" do
      let(:source_path) { "foo.html.erb" }
      it { is_expected.to eq template_root.join(source_path) }
    end

    context "when specified source path is absolute" do
      let(:source_path) { template_root.join("foo.html.erb") }
      it { is_expected.to eq source_path }
    end
  end
end
