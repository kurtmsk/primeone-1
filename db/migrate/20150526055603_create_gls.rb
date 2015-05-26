class CreateGls < ActiveRecord::Migration
  def change
    create_table :gls do |t|

      t.integer :premium_total, default: 0
      t.integer :premium_subtotal, default: 0
      t.integer :schedule_rating, default: 0
      t.integer :multi_loc_factor, default: 0
      t.integer :gas_premium, default: 0
      t.integer :rate, default: 0
      t.string :water_gas_tank, default: ""
      t.integer :add_ins_number, default: 0
      t.string :territory, default: ""
      t.string :comments, default: ""

      # Limits
      t.integer :gen_agg, default: 0
      t.integer :products_completed_operations, default: 0
      t.integer :personal_advertising_injury, default: 0
      t.integer :each_occurence, default: 0
      t.integer :fire_damage, default: 0
      t.integer :medical_expense, default: 0

      # has_many exposure_gls

      t.timestamps null: false
    end

    add_reference :gls, :policy, index: true, foreign_key: true
  end
end
