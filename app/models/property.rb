class Property < ActiveRecord::Base
  # Associations
  belongs_to :policy
  has_many :locations
end
