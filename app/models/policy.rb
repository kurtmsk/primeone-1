class Policy < ActiveRecord::Base
  # Validations
  validates :policy_number, presence: true, uniqueness: true

  # Associations
  belongs_to :broker
  has_one :property, dependent: :destroy
  has_one :crime, dependent: :destroy
  has_one :gl, dependent: :destroy
  has_one :auto, dependent: :destroy

  accepts_nested_attributes_for :property, allow_destroy: true
  accepts_nested_attributes_for :gl, allow_destroy: true
  accepts_nested_attributes_for :crime, allow_destroy: true
  accepts_nested_attributes_for :auto, allow_destroy: true
end
