require 'rails_helper'

RSpec.describe Gakubuchi do
  describe '.configuration' do
    subject { described_class.configuration }
    it { is_expected.to be_a_kind_of(Gakubuchi::Configuration) }
  end
end
