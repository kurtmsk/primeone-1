class Property < ActiveRecord::Base
  # Associations
  belongs_to :policy
  has_many :locations, dependent: :destroy

  accepts_nested_attributes_for :locations
end
