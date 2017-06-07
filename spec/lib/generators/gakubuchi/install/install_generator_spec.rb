require "rails_helper"
require "ammeter/init"
require "generators/gakubuchi/install/install_generator"

RSpec.describe Gakubuchi::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe "generated files" do
    before do
      run_generator(args)
    end

    describe "config/initializers/gakubuchi.rb" do
      subject { file("config/initializers/gakubuchi.rb") }

      let(:expected_content) do
        /\A
          Gakubuchi\.configure\ do\ \|config\|\n
          .*
          \#\ config.leave_digest_named_templates\ =\ false\n
          .*
          #{expected_configuration}\n
          .*
          end
        \Z/mx
      end

      context "when directory is not specified" do
        let(:args) { [] }
        let(:expected_configuration) { %q(\#\ config.template_directory\ =\ 'templates') }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain expected_content }
      end

      context "when directory is specified" do
        let(:args) { %w(--directory=foo) }
        let(:expected_configuration) { %q(config.template_directory\ =\ 'foo') }

        it { is_expected.to exist }
        it { is_expected.to have_correct_syntax }
        it { is_expected.to contain expected_content }
      end
    end
  end

  after(:context) do
    FileUtils.rm_rf(destination_root, secure: true)
  end
end
