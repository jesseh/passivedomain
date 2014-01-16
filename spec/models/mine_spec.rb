require "spec_helper"

describe Mine do

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    electricity_rate:      EnergyCost.new(UsCurrency.cents(25)),
    pool_fee_percent:      Percent.decimal(0.07),
    facility_cost:         UsDollarRate.per_month(UsCurrency.dollars(73)),
    other_cost:            UsDollarRate.per_month(UsCurrency.dollars(97)),
    rig_utilization:       Percent.decimal(0.50),
  }) }

  subject { described_class.new(data) } 

  it { expect(subject.other_cost.to_s).to      be }

end
