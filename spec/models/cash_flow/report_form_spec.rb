require "spec_helper"

describe CashFlow::ReportForm do

  let(:data){ {
    :cooling_electricity   => 1,
    :electricity_rate      => 1,
    :facility_fees         => 1,
    :hash_rate             => 1,
    :mining_electricity    => 1,
    :other_operating_costs => 1,
    :pool_percentage       => 10,
    :rig_utilization       => 1
  } }

  subject { described_class.new(data) }

  it_should_behave_like "CashFlow::Report data"

end
