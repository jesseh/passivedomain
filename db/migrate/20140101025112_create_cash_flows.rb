class CreateCashFlows < ActiveRecord::Migration
  def change
    create_table :cash_flows do |t|
      t.string :fiat_currency
      t.decimal :exchange_rate, precision: 10, scale: 6
      t.string :objective
      t.decimal :rig_hash_rate, precision: 10, scale: 4
      t.float :watts_to_mine
      t.float :watts_to_cool
      t.decimal :electricity_rate_fractional, precision: 10, scale: 4
      t.float :rig_utilization
      t.decimal :pool_fee_percent, precision: 4, scale: 2
      t.decimal :facility_cost_fractional, precision: 10, scale: 4
      t.string :exchange_provider
      t.decimal :other_cost_fractional, precision: 10, scale: 4
      t.float :mining_difficulty
      t.decimal :reward_amount_fractional, precision: 10, scale: 4

      t.timestamps
    end
  end
end
