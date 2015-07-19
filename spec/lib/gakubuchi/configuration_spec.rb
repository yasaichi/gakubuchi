require 'rails_helper'

RSpec.describe Gakubuchi::Configuration do
  let(:configuration) { Gakubuchi::Configuration.new }

  describe '#to_h' do
    subject { configuration.to_h }
    it { is_expected.to be_a_kind_of(Hash) }
  end
end
