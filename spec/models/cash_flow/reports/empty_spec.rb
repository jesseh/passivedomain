require "spec_helper"

describe CashFlow::Reports::Empty do
  let(:interface){ PassiveDomain::Interface.new(described_class) }
  let(:data) { interface.responder() }

  subject { described_class.new(data) }

  #it_should_behave_like("CashFlow::Report interface")

  its(:units) { should == "" }
  its(:revenue)                 { should == ''  }
  its(:pool_fees)               { should == ''  }
  its(:electricity_cost)        { should == ''  }
  its(:operating_exchange_fees) { should == ''  }
  its(:revenue_exchange_fees)   { should be_nil }
  its(:gross_margin)            { should == ''  }
  its(:facility_cost)           { should == ''  }
  its(:other_cost)              { should == ''  }
  its(:ebitda)                  { should == ''  }

  #TODO - tests are missing here.
end
