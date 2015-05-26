class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :number, default: 0

      t.integer :premium, default: 0
      t.integer :co_ins, default: 0
      t.integer :co_ins_factor, default: 0
      t.integer :ded, default: 0
      t.integer :ded_factor, default: 0

      # Location Address
      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""

      # Building Exposure
      t.string :bldg_exp__business_type, default: ""
      t.string :bldg_exp__coverage_type, default: ""
      t.string :bldg_exp__construction_type, default: ""
      t.string :bldg_exp__protection_class, default: ""
      t.string :bldg_exp__updates, default: ""
      t.string :bldg_exp__year_built, default: ""
      t.integer :bldg_exp__stories, default: ""
      t.integer :bldg_exp__square_feet, default: ""
      t.integer :bldg_exp__parking_lot, default: ""

      # Food Spoilage
      t.string :food__facticity, default: ""
      t.integer :food__limit, default: ""
      t.integer :food__rate, default: ""
      t.integer :food__premium, default: ""

      # Theft
      t.string :theft__facticity, default: ""
      t.integer :theft__limit, default: ""
      t.integer :theft__rate, default: ""
      t.integer :theft__premium, default: ""

      # Property Enhancement
      t.string :enhc__facticity, default: ""
      t.integer :enhc__limit, default: ""
      t.integer :enhc__rate, default: ""
      t.integer :enhc__premium, default: ""

      # Mechanical Breakdown
      t.string :mech__facticity, default: ""
      t.integer :mech__limit, default: ""
      t.integer :mech__rate, default: ""
      t.integer :mech__premium, default: ""

      # has_many Exposures

      t.timestamps null: false
    end

    add_reference :locations, :policy, index: true, foreign_key: true
  end
end
