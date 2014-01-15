require 'ostruct'

class WhenToMine::CalculatorsController < ApplicationController
  
  def show
    record = data_source()
    data = CashFlow::Mapper.new(record)
    @report = CashFlow::Report.new(data)
  end


private

  def data_source
    data = OpenStruct.new

    data.rig_hash_rate               = 123
    data.mining_difficulty           = 123
    data.reward_amount_fractional    = 123
    data.other_cost_fractional       = 123
    data.facility_cost_fractional    = 123
    data.electricity_rate_fractional = 123
    data.watts_to_mine               = 123
    data.watts_to_cool               = 123
    data.pool_fee_percent            = 0.07
    data.rig_utilization             = 0.5
    data.mining_difficulty           = 123456
    data.exchange_fee_percent        = 0.05
    data.exchange_rate               = 59
  end

  def not_found
    head :not_found
  end

end
