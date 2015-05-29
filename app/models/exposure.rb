class Exposure < ActiveRecord::Base
  # Associations
  belongs_to :location
  belongs_to :crime


  default_scope { order('created_at ASC') }
end
