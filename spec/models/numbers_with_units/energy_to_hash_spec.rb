require "spec_helper"
require "numbers_with_units"

module NumbersWithUnits
  describe NumbersWithUnits::EnergyToHash do
    subject { described_class.factors(Power.watts(35), 
                                      HashRate.hash_per_second(10)
                                     )}

    it_behaves_like 'number with units'

    its(:to_s)  { should == '3.5 (watts / second) / hash' }
  end
end
