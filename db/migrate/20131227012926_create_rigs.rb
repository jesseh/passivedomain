class CreateRigs < ActiveRecord::Migration
  def change
    create_table :rigs do |t|
      t.string :name

      t.integer :price_fractional
      t.string  :price_currency

      t.integer :power
      t.float   :hash_rate
    end
  end
end
