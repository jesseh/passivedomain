require 'spec_helper'

describe MiningHash do

  subject { described_class.new(1.23) }

  it_behaves_like 'number with units'

  its(:to_s) { should == '1.23 hashes' }
  its(:giga) { should == '1.23E-09 gigahashes' }
  its(:number) { should == 1.23 }
  its(:gigahash_number) { should == 1.23E-9 }
end
