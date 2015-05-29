class Location < ActiveRecord::Base
  # Associations
  belongs_to :property
  has_many :exposures, dependent: :destroy

  default_scope { order('created_at ASC') }
end
