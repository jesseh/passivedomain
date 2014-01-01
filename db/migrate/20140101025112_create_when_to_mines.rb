class CreateWhenToMines < ActiveRecord::Migration
  def change
    create_table :when_to_mines do |t|
      t.string :fiat_currency
      t.decimal :exchange_rate
      t.string :objective
      t.float :rig_hash_rate
      t.float :watts_to_mine
      t.float :watts_to_cool
      t.decimal :electricity_rate
      t.float :rig_utilization
      t.float :pool_fee_percent
      t.decimal :facility_cost
      t.string :exchange_provider
      t.decimal :other_operating_costs
      t.float :mining_difficulty
      t.decimal :reward_amount

      t.timestamps
    end
  end
end
