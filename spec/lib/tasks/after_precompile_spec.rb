require "rails_helper"

describe "rake assets:precompile" do
  describe "precompiled templates" do
    subject { Pathname.glob(Rails.public_path.join("**/*.html")) }

    let(:expectation) do
      [
        Rails.public_path.join("foo.html"),
        Rails.public_path.join("bar/baz.html"),
        Rails.public_path.join("qux.html"),
        Rails.public_path.join("quux.html"),
        Rails.public_path.join("quuz.ja.html")
      ]
    end

    before do
      Rake::Task["assets:precompile"].execute
    end

    it { is_expected.to match_array(expectation) }
  end

  describe "task" do
    let(:task) { double(:task, execute!: true) }

    before do
      allow(Gakubuchi::Task).to receive(:new).and_return(task)
      Rake::Task["assets:precompile"].execute
    end

    it { expect(Gakubuchi::Task).to have_received(:new).with(Gakubuchi::Template.all) }
    it { expect(task).to have_received(:execute!) }
  end

  after do
    Rake::Task["assets:clobber"].execute
    FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
  end
end
