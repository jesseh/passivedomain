shared_examples "CashFlow::Report data" do
  it { should respond_to :rig_hash_rate }
  it { should respond_to :watts_to_mine }
  it { should respond_to :watts_to_cool }
  it { should respond_to :mining_effort }
  it { should respond_to :reward_amount }
  it { should respond_to :electricity_rate }
  it { should respond_to :pool_fee_percent }
  it { should respond_to :facility_cost }
  it { should respond_to :other_cost }
  it { should respond_to :exchange_fee_percent }
  it { should respond_to :exchange_rate }
  it { should respond_to :rig_utilization }
end

shared_examples "CashFlow::Report interface" do
  it { should respond_to :revenue }
  it { should respond_to :pool_fees }
  it { should respond_to :revenue_exchange_fees }
  it { should respond_to :operating_exchange_fees }
  it { should respond_to :electricity_cost }
  it { should respond_to :gross_margin }
  it { should respond_to :other_cost }
  it { should respond_to :facility_cost }
  it { should respond_to :ebitda }
end
