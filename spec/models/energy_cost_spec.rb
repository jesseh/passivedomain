require "spec_helper"

describe EnergyCost do

  subject { described_class.new(UsCurrency.cents(333), Energy.kilowatt_hours(3)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.11 USD / kWh' }
end
