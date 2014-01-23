
shared_examples "CashFlow::Report data" do

  CashFlow::Report.interface.map(&:source).each do |source|
    it { should respond_to source }
  end
end

shared_examples "CashFlow::Report interface" do
  it { should respond_to :exchange }
  it { should respond_to :network }
  it { should respond_to :rig_capacity_value }
  it { should respond_to :rig_capacity_unit }
  it { should respond_to :rig_efficiency_value }
  it { should respond_to :rig_efficiency_unit }
  it { should respond_to :rig_utilization_value }
  it { should respond_to :rig_utilization_unit }
  it { should respond_to :other_cost_value }
  it { should respond_to :other_cost_unit }
  it { should respond_to :facility_cost_value }
  it { should respond_to :facility_cost_unit }
  it { should respond_to :revenue_value }
  it { should respond_to :revenue_unit }
  it { should respond_to :pool_fees_value }
  it { should respond_to :pool_fees_unit }
end
