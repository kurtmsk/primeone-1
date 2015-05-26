class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :name, default: ""
      t.string :dba, default: ""

      t.string :contact_name, default: ""
      t.string :email, default: ""
      t.string :phone, default: ""
      t.text :notes, default: ""

      t.integer :commission, default: 0
      t.string :agreement_sent, default: ""
      t.string :agreement_completed, default: ""
      t.string :pac_risk_fee_schedule, default: ""
      t.string :target_premium, default: ""

      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""

      t.timestamps null: false
    end
    add_index :brokers, :name, unique: true
  end
end
