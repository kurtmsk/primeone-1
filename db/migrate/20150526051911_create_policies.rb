class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|

      t.string :policy_number, default: ""
      t.string :status, default: ""
      t.string :client_code, default: ""

      t.date :effective_date
      t.date :expiration_date

      t.string :forms, default: ""
      t.string :property_forms, default: ""
      t.string :gl_forms, default: ""
      t.string :crime_forms, default: ""
      t.string :auto_forms, default: ""

      t.integer :package_premium_total, default: 0

      t.timestamps null: false
    end

    add_index :policies, :policy_number, unique: true
    add_reference :policies, :broker, index: true, foreign_key: true
  end
end
