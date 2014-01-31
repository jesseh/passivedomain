require "spec_helper"

describe CashFlow::Reports::Acquire do
  let(:interface){ PassiveDomain::Interface.new(described_class) }
  let(:data) { interface.responder(objective: 'acquire'.freeze) }

  subject { described_class.new(data) }

  #it_should_behave_like("CashFlow::Report interface")

  its(:units) { should == "Bitcoin per month" }
  its(:revenue)                 { should be_a_kind_of(Numeric) } #TODO figure out the math here
  its(:pool_fees)               { should be_a_kind_of(Numeric) }
  its(:electricity_cost)        { should be_a_kind_of(Numeric) }
  its(:revenue_exchange_fees)   { should be_nil }
  its(:operating_exchange_fees) { should be_nil }
  its(:gross_margin)            { should be_a_kind_of(Numeric) }
  its(:facility_cost)           { should be_a_kind_of(Numeric) }
  its(:other_cost)              { should be_a_kind_of(Numeric) }
  its(:ebitda)                  { should be_a_kind_of(Numeric) } #TODO figure out the math here

  #TODO - tests are missing here.
end
