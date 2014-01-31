
require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  module Report

    def self.create(data)
      options = [CashFlow::Reports::Acquire,
                 CashFlow::Reports::Retain,
                 CashFlow::Reports::Extract,
                 CashFlow::Reports::Empty,
                ]
      
      # There is a better way to do this that does not hit exceptions.  But it
      # depends on being able to ask for a classes interface (perhaps via an
      # interface registry?).# So for the moment this hack will do.
      
      report = nil
      options.each do |option|
        begin
          report = option.new(data) 
          break
        rescue PassiveDomain::ValidationError => e
          report = nil
          next
        end
      end
      if report.nil?
        raise PassiveDomain::ValidationError, "No report can be created with this data."
      end
      report
    end


    ### Methods to be included in reports ###
    
    def mine
      raise NotImplementedError
    end

    def units
      raise NotImplementedError
    end

    def revenue
      convert(mine.revenue.monthly_value).value
    end

    def pool_fees
      convert(mine.pool_fees.monthly_value).value
    end

    def revenue_exchange_fees
      nil
    end

    def electricity_cost
      convert(mine.electricity_cost.monthly_value).value
    end

    def gross_margin
      revenue - electricity_cost - pool_fees
    end

    def facility_cost
      convert(mine.facility_cost.monthly_value).value
    end

    def other_cost
      convert(mine.other_cost.monthly_value).value
    end

    def operating_exchange_fees
      nil
    end

    def ebitda
        gross_margin - facility_cost - other_cost
    end



    private

    def convert(amount)
      amount
    end

  end
end

