require "spec_helper"
require_dependency "numbers_with_units"

describe Mine do
  include NumbersWithUnits

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    electricity_rate:      energy_cost.us_cents_per_kwh(25),
    pool_fee_percent:      percent.decimal(0.07),
    facility_cost:         us_dollar_rate.per_month(73),
    other_cost:            us_dollar_rate.per_month(97),
    rig_utilization:       percent.decimal(0.50),
  }) }

  subject { described_class.new(data) } 

  its(:electricity_rate) { should be }
  its(:pool_fee_percent) { should be }
  its(:facility_cost) { should be }
  its(:other_cost) { should be }
  its(:rig_utilization) { should be }

end
