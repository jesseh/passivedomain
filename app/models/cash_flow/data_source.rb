module CashFlow
  class DataSource 

    def initialize(mapper_class=CashFlow::Mapper)
      @mapper_class = mapper_class
    end

    def canned
      @mapper_class.new(canned_data)
    end

    private

    def canned_data
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

      data
    end

  end
end
