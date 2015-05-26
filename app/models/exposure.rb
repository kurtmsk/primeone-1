class Exposure < ActiveRecord::Base
  # Associations
  belongs_to :location
  belongs_to :crime
end
