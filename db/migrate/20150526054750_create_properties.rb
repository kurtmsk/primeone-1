class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      
      t.integer :premium_total, default: 0
      t.integer :schedule_rating_pct, default: 0
      t.integer :premium_subtotal, default: 0

      # has_many locations

      t.timestamps null: false
    end

    add_reference :properties, :policy, index: true, foreign_key: true
  end
end
