require "spec_helper"

describe EnergyToHash do
  let(:hash_rate) { HashRate.hashes_per_time_span(MiningHash(10), Timespan.seconds(1)) }

  subject { described_class.power_for_hash_rate(
    Power.watts(35), 
    HashRate.new(MiningHash.new(10), Timespan.seconds(1))
  )}

  it_behaves_like 'number with units'

  its(:to_s)  { should == '3.5 (watts / second) / hash' }
end
