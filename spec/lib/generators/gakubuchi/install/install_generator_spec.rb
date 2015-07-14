require 'rails_helper'
require 'ammeter/init'
require 'generators/gakubuchi/install/install_generator'

RSpec.describe Gakubuchi::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../tmp', __FILE__)

  before do
    prepare_destination
  end

  describe 'generated files' do
    before do
      run_generator
    end

    describe 'config/initializers/gakubuchi.rb' do
      subject { file('config/initializers/gakubuchi.rb') }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain /\AGakubuchi\.configure do \|config\|\n.*end\Z/m }
    end
  end

  after(:context) do
    FileUtils.rm_rf(destination_root)
  end
end
