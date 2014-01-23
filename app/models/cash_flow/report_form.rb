# Used to take input from HTTP params and populate a report object
require_dependency Rails.root.join('lib', 'passive_domain').to_s

class CashFlow::ReportForm
  extend PassiveDomain

  value_object_initializer

  attr_reader :rig_hash_rate,
              :electricity_rate,
              :facility_cost,
              :other_cost,
              :reward_amount,
              :mining_effort,
              :watts_to_mine,
              :watts_to_cool,
              :pool_fee_percent,
              :rig_utilization,
              :mining_effort,
              :exchange_fee_percent,
              :exchange_rate

end
