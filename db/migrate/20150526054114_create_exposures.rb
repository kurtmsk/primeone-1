class CreateExposures < ActiveRecord::Migration
  def change
    create_table :exposures do |t|
      t.string :name, default: ""
      t.string :valuation, default: 0
      t.integer :limit, default: 0
      t.integer :rate, default: 0
      t.integer :ded_factor, default: 0
      t.integer :co_ins_factor, default: 0
      t.integer :premium, default: 0

      t.timestamps null: false
    end

    add_reference :exposures, :location, index: true, foreign_key: true
  end
end
