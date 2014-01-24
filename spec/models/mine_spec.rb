require "spec_helper"

describe Mine do

  it_behaves_like 'value object'

  let(:data) { double("Data", {
    electricity_rate:      EnergyCost.new(UsCurrency.cents(25)),
    pool_fee_percent:      Percent.decimal(0.07),
    facility_cost:         UsDollarRate.per_month(UsCurrency.dollars(73)),
    other_cost:            UsDollarRate.per_month(UsCurrency.dollars(97)),
    rig_utilization:       Percent.decimal(0.50),
    rig_hash_rate:         HashRate.new(MiningHash.new(1E9)),
    watts_to_mine:         Power.watts(40),
    watts_to_cool:         Power.watts(60),
    mining_effort:         MiningEffort.new(1E5),
    reward_amount:         Bitcoin.new(1)
  }) }

  subject { described_class.new(data) }

  #TODO improve these tests
  it { expect(subject.other_cost.to_s).to      be }
  it { expect(subject.revenue).to              be_an_instance_of(BitcoinRate) }
  it { expect(subject.pool_fees).to            be }
  it { expect(subject.electricity_cost).to     be }

end
