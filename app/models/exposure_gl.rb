class ExposureGl < ActiveRecord::Base
  # Associations
  belongs_to :gl

  default_scope { order('created_at ASC') }
end
