require "spec_helper"

describe HashRate do

  subject { described_class.new(MiningHash.new(123), Timespan.seconds(1)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123 hashes / second' }
  its(:hash_per_second) { should == 123 }
  its(:gigahash_per_hour) { should == (123.0 * 60 * 60 / 1E9).round(8) }
  its(:base_unit_number) { should == 123 }

end
