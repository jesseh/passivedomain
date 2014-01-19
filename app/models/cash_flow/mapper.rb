require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Mapper 
    extend CustomInitializers

    value_object_initializer(
      ask(:rig_hash_rate,               only.positive_number){
        |raw| HashRate.new(MiningHash.new(raw), Timespan.second)
      },
      ask(:watts_to_mine,               only.positive_number) {
        |raw| Power.watts(raw)
      },
      ask(:watts_to_cool,               only.positive_number) {
        |raw| Power.watts(raw)
      },
      ask(:pool_fee_percent,            only.number_within(0...1)) {
        |raw| Percent.decimal(raw)
      },
      ask(:rig_utilization,             only.number_within(0...1)) {
        |raw| Percent.decimal(raw)
      },
      ask(:exchange_fee_percent,        only.number_within(0...1)) {
        |raw| Percent.decimal(raw)
      },
      ask(:exchange_rate,               only.positive_number),
      
      ask(:mining_difficulty,           only.positive_number) {
        |raw| MiningEffort.new(raw)
      } => :mining_effort,

      ask(:reward_amount_fractional,    only.positive_integer) {
        |raw| Bitcoin.new(raw) 
      } => :reward_amount,

      ask(:other_cost_fractional,       only.positive_number) { 
        |raw| UsDollarRate.per_month(UsCurrency.cents(raw))
      } => :other_cost,

      ask(:facility_cost_fractional,    only.positive_number) {
        |raw| UsDollarRate.per_month(UsCurrency.cents(raw))
      } => :facility_cost,

      ask(:electricity_rate_fractional, only.positive_number) {
        |raw| EnergyCost.new(UsCurrency.cents(raw))
      } => :electricity_rate
    )





    attr_reader :rig_hash_rate,
                :electricity_rate,
                :facility_cost,
                :other_cost,
                :reward_amount,
                :mining_effort,
                :watts_to_mine,
                :watts_to_cool,
                :rig_utilization,
                :mining_effort,
                :exchange_fee_percent,
                :exchange_rate


  end
end
