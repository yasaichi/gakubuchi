require "rails_helper"

RSpec.describe Gakubuchi::Railtie do
  describe ".rake_tasks" do
    describe 'Rake.application["assets:clobber"]' do
      subject { Pathname.glob(Rails.public_path.join("*")) }

      before do
        Rake.application["assets:precompile"].execute
        Rake.application["assets:clobber"].execute
      end

      it { is_expected.to eq [] }
    end

    describe 'Rake.application["assets:precompile"]' do
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
        Rake.application["assets:precompile"].execute
      end

      it { is_expected.to match_array(expectation) }

      after do
        FileUtils.rm_r(Dir.glob(Rails.public_path.join("*")), secure: true)
      end
    end
  end
end
