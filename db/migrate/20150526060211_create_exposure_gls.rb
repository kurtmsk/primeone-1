class CreateExposureGls < ActiveRecord::Migration
  def change
    create_table :exposure_gls do |t|

      t.string :name, default: ""
      t.integer :loc_number, default: 0
      t.string :description, default: ""
      t.string :cov, default: ""
      t.string :code, default: ""
      t.integer :premium_basis, default: 0
      t.string :type, default: ""
      t.integer :base_rate, default: 0
      t.integer :ilf, default: 0
      t.integer :premium, default: 0

      t.timestamps null: false
    end

    add_reference :exposure_gls, :gl, index: true, foreign_key: true
  end
end
