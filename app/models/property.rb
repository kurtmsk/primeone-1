class Property < ActiveRecord::Base
  # Associations
  belongs_to :policy
  has_many :locations, dependent: :destroy
end
