require "rails_helper"

RSpec.describe Gakubuchi::RakeTask do
  let(:rake_task) { described_class.new(application) }
  let(:application) { Rake::Application.new }

  describe ".enhance" do
    subject { proc { |block| described_class.enhance(application, &block) } }

    before do
      application.define_task(Rake::Task, "assets:clobber")
      application.define_task(Rake::Task, "assets:precompile")
      expect_any_instance_of(described_class).to receive(:enhance)
    end

    it { expect(&subject).to yield_with_args(an_instance_of(described_class)) }
    it { expect(subject.call).to be_an_instance_of(described_class) }
  end

  describe "#configuration" do
    subject { rake_task.configuration }
    it { is_expected.to be_an_instance_of(Gakubuchi::Configuration) }
  end

  describe "#enhance" do
    let(:destination_path) { template.destination_path }
    let(:digest_path) { template.digest_path }
    let(:template) { Gakubuchi::Template.new("bar/baz.html.erb") }

    before do
      application.define_task(Rake::Task, "assets:clobber")
      application.define_task(Rake::Task, "assets:precompile")

      rake_task.templates = template
      rake_task.enhance
    end

    describe '#application["assets:precompile"]' do
      subject { -> { rake_task.application["assets:precompile"].execute } }

      let(:expected_log_messeage) do
        /\A
          .*Copied\ #{digest_path}\ to\ #{destination_path}\n
          .*Removed\ #{digest_path}\ #{digest_path}.gz
        \Z/mx
      end

      before do
        FileUtils.mkdir_p(digest_path.dirname)
        File.write(digest_path, "")
        File.write("#{digest_path}.gz", "")
      end

      it "generates the non-digest-named copy, and then removes the source" do
        expect(&subject).to output(expected_log_messeage).to_stdout

        expect(File.exist?(destination_path)).to eq true
        expect(File.exist?(digest_path)).to eq false
        expect(File.exist?("#{digest_path}.gz")).to eq false
      end

      after do
        FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
      end
    end

    describe '#application["assets:clobber"]' do
      subject { -> { rake_task.application["assets:clobber"].execute } }

      let(:expected_log_messeage) do
        /\A
          .*Removed\ #{destination_path}\n
          .*Removed\ #{destination_path.dirname}
        \Z/mx
      end

      before do
        FileUtils.mkdir_p(destination_path.dirname)
        File.write(destination_path, "")
      end

      it "removes the non-digest-named copy" do
        expect(&subject).to output(expected_log_messeage).to_stdout

        expect(File.exist?(destination_path)).to eq false
        expect(File.exist?(destination_path.dirname)).to eq false
      end
    end
  end

  describe "#task" do
    subject { rake_task.task }
    let(:configuration) { Gakubuchi::Configuration.new }

    before do
      rake_task.configuration = configuration
    end

    it { is_expected.to be_an_instance_of(Gakubuchi::Task) }
    its(:configuration) { is_expected.to equal configuration }
  end

  describe "#templates" do
    subject { rake_task.templates }
    it { is_expected.to eq [] }
  end
end
