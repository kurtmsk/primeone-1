class Location < ActiveRecord::Base
  # Associations
  belongs_to :property
  has_many :exposures
end
