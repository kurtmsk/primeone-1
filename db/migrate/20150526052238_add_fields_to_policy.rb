class AddFieldsToPolicy < ActiveRecord::Migration
  def change
    # Insured
    add_column :policies, :name, :string, default: ""
    add_column :policies, :quoted_by, :string, default: ""
    add_column :policies, :business_type, :string, default: ""
    add_column :policies, :mortgagee, :string, default: ""
    add_column :policies, :insured_type, :string, default: ""

    # Mailing Address
    add_column :policies, :street, :string, default: ""
    add_column :policies, :city, :string, default: ""
    add_column :policies, :state, :string, default: ""
    add_column :policies, :zip, :string, default: ""

    # has_one Property

    # has_one Crime

    # has_one General Liability (gl)

    # has_one Commercial Auto (auto)
  end
end
