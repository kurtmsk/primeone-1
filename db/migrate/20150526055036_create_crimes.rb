class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
      
      t.integer :premium_total, default: 0
      t.integer :premium_subtotal, default: 0
      t.integer :schedule_rating, default: 0
      t.string :burglar_alarm, default: ""
      t.string :exclude_safe, default: ""
      t.integer :ded, default: 0

      # has_many exposures

      t.timestamps null: false
    end

    add_reference :crimes, :policy, index: true, foreign_key: true
  end
end
