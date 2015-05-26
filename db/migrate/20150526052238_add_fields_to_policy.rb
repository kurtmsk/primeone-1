class AddFieldsToPolicy < ActiveRecord::Migration
  def change
    # Insured
    add_column :policies, :insured__name, :string, default: ""
    add_column :policies, :insured__quoted_by, :string, default: ""
    add_column :policies, :insured__business_type, :string, default: ""
    add_column :policies, :insured__mortgagee, :string, default: ""
    add_column :policies, :insured__type, :string, default: ""

    # Mailing Address
    add_column :policies, :maddress__street, :string, default: ""
    add_column :policies, :maddress__city, :string, default: ""
    add_column :policies, :maddress__state, :string, default: ""
    add_column :policies, :maddress__zip, :string, default: ""

    # Agency
    # add_column :policies, :agency__mortgagee, :string, default: ""

    # Property
    add_column :policies, :property__schedule_rating_pct, :integer, default: 0
    add_column :policies, :property__premium_subtotal, :integer, default: 0
    add_column :policies, :property__premium_total, :integer, default: 0
    # has_many locations

    
  end
end
