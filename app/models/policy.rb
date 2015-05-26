class Policy < ActiveRecord::Base
  # Validations
  validates :policy_number, presence: true, uniqueness: true

  # Associations
  belongs_to :broker
  has_many :locations
end
