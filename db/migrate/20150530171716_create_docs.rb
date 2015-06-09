class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :file, default: ""
      t.string :form_code, default: ""
      t.string :description, default: ""
      t.string :var_1, default: ""
      t.string :var_2, default: ""
      t.string :var_3, default: ""
      t.string :var_4, default: ""
      t.string :var_5, default: ""
      t.string :var_6, default: ""

      t.boolean :active, default: false

      t.timestamps null: false
    end

    add_reference :docs, :policy, index: true, foreign_key: true
  end
end
