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
      t.string :business_type, default: ""
      t.string :coverage_type, default: ""
      t.string :construction_type, default: ""
      t.string :protection_class, default: ""
      t.string :updates, default: ""
      t.string :year_built, default: ""
      t.integer :stories, default: ""
      t.integer :square_feet, default: ""
      t.integer :parking_lot, default: ""

      # Food Spoilage
      #t.string :food_facticity, default: ""
      t.integer :food_limit, default: ""
      t.integer :food_rate, default: ""
      t.integer :food_premium, default: ""

      # Theft
      #t.string :theft_facticity, default: ""
      t.integer :theft_limit, default: ""
      t.integer :theft_rate, default: ""
      t.integer :theft_premium, default: ""

      # Property Enhancement
      #t.string :enhc_facticity, default: ""
      t.integer :enhc_limit, default: ""
      t.integer :enhc_rate, default: ""
      t.integer :enhc_premium, default: ""

      # Mechanical Breakdown
      #t.string :mech_facticity, default: ""
      t.integer :mech_limit, default: ""
      t.integer :mech_rate, default: ""
      t.integer :mech_premium, default: ""

      # has_many Exposures

      t.timestamps null: false
    end

    add_reference :locations, :property, index: true, foreign_key: true
  end
end
