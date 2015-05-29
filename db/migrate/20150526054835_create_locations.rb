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
      t.integer :stories, default: 0
      t.integer :square_feet, default: 0
      t.integer :parking_lot, default: 0

      # Food Spoilage
      #t.string :food_facticity, default: ""
      #t.integer :food_limit, default: 0
      t.integer :food_rate, default: 0
      t.integer :food_premium, default: 0

      # Theft
      #t.string :theft_facticity, default: ""
      t.integer :theft_limit, default: 0
      #t.integer :theft_rate, default: 0
      t.integer :theft_premium, default: 0

      # Property Enhancement
      #t.string :enhc_facticity, default: ""
      #t.integer :enhc_limit, default: 0
      t.integer :enhc_rate, default: 0
      t.integer :enhc_premium, default: 0

      # Mechanical Breakdown
      #t.string :mech_facticity, default: ""
      #t.integer :mech_limit, default: 0
      #t.integer :mech_rate, default: 0
      t.integer :mech_premium, default: 0

      # has_many Exposures
      # Building/IBB --> 0
      # BPP: --> 1
      # Earnings: --> 2
      # Sign:   --> 3
      # Pumps: --> 4
      # Canopies: --> 5
      # Other:  --> 6

      t.timestamps null: false
    end

    add_reference :locations, :property, index: true, foreign_key: true
  end
end
