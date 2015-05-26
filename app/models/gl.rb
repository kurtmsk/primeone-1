class Gl < ActiveRecord::Base
  # Associations
  belongs_to :policy
  has_many :exposure_gls
end
