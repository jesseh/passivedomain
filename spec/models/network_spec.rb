require "spec_helper"
require_dependency "numbers_with_units"

describe Network do
  include NumbersWithUnits

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    mining_difficulty:     1180923195.25800,
    reward_amount:         reward_rate.bitcoin_per_block(25),
  }) }
  subject { described_class.new(data) } 

end
