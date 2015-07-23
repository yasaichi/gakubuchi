require 'rails_helper'

describe 'rake assets:precompile' do
  before(:context) do
    Rails.application.load_tasks
  end

  describe 'task' do
    let(:task) { double(:task, execute!: true) }

    before do
      allow(Gakubuchi::Task).to receive(:new).and_return(task)
      Rake::Task['assets:precompile'].execute
    end

    it { expect(Gakubuchi::Task).to have_received(:new).with(Gakubuchi::Template.all) }
    it { expect(task).to have_received(:execute!) }
  end

  after do
    Rake::Task['assets:clobber'].execute
    FileUtils.rm_r(Dir.glob(Rails.public_path.join('*')), secure: true)
  end
end
