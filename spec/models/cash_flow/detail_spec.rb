require "spec_helper"

describe CashFlow::Detail do

  let(:mining_difficulty) { 25 }
  let(:rig_hash_rate)     { 1E12 }
  let(:data) { double("Data", { 
    rig_hash_rate:         HashRate.from_base_unit(rig_hash_rate),
    watts_to_mine:         Power.from_base_unit(33),
    watts_to_cool:         Power.from_base_unit(81),
    mining_difficulty:     MiningEffort.from_base_unit(mining_difficulty),
    reward_amount:         Bitcoin.from_base_unit(25),
    electricity_rate:      EnergyCost.from_base_unit(25),
    pool_fee_percent:      Percent.from_base_unit(0.07),
    facility_cost:         UsDollarRate.from_base_unit(73),
    other_cost:            UsDollarRate.from_base_unit(97),
    exchange_fee_percent:  Percent.from_base_unit(0.07),
    exchange_rate:         1,
    rig_utilization:       Percent.from_base_unit(0.50),
  }) }
  subject { described_class.new(data) } 

  its(:rig)      { should == Rig.new(data)      }
  its(:mine)     { should == Mine.new(data)     }
  its(:network)  { should == Network.new(data)  }
  its(:exchange) { should == Exchange.new(data) }


  describe "#expected_reward_rate" do
    let(:mining_difficulty) { 1E-12 }

    its(:expected_reward_rate) { should == BitcoinRate.from_base_unit(0.006944444) }
  end
end
