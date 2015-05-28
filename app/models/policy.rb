class Policy < ActiveRecord::Base
  # Validations
  validates :policy_number, presence: true, uniqueness: true

  # Associations
  belongs_to :broker
  has_one :property
  has_one :crime
  has_one :gl
  has_one :auto

  #accepts_nested_attributes_for :property, allow_destroy: true
end
