class Location < ActiveRecord::Base
  # Associations
  belongs_to :policy
  has_many :exposures
end
