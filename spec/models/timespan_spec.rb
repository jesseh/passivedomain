require 'spec_helper'

describe Timespan do

  it { expect(described_class.second).to eq(described_class.from_base_unit(1)) }
  it { expect(described_class.hour).to eq(described_class.from_base_unit(3600)) }
  it { expect(described_class.month).to eq(described_class.from_base_unit(3600 * 730)) }
  subject { described_class.seconds(1.23) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.23 seconds' }
end
