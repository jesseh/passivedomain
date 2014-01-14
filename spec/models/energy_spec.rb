require "spec_helper"
require "numbers_with_units"

describe Energy do

  subject { described_class.kilowatt_hours(123) }

  it_behaves_like 'number with units'

  its(:to_s)            { should == '123.0 kilowatt hours' }
  its(:kilowatt_hours)  { should == 123.0 }

end
