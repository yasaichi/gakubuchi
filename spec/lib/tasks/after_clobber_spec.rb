require "rails_helper"

describe "rake assets:clobber" do
  subject { Pathname.glob(Rails.public_path.join("**/*.html")) }

  context "before `assets:precompile` is executed" do
    before do
      Rake::Task["assets:clobber"].execute
    end

    it { is_expected.to eq [] }
  end

  context "after `assets:precompile` is executed" do
    before do
      Rake::Task["assets:precompile"].execute
      Rake::Task["assets:clobber"].execute
    end

    it { is_expected.to eq [] }
  end

  after do
    FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
  end
end
