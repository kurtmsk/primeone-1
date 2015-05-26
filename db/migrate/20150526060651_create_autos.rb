class CreateAutos < ActiveRecord::Migration
  def change
    create_table :autos do |t|
      t.integer :premium_total, default: 0
      t.integer :locations, default: 0
      t.string :hired_auto, default: ""
      t.integer :hired_auto_premium, default: 0

      t.timestamps null: false
    end

    add_reference :autos, :policy, index: true, foreign_key: true
  end
end
