class Policy < ActiveRecord::Base
  # Validations
  validates :policy_number, presence: true, uniqueness: true

  # Associations
  belongs_to :broker
  has_many :docs, dependent: :destroy
  has_one :property, dependent: :destroy
  has_one :crime, dependent: :destroy
  has_one :gl, dependent: :destroy
  has_one :auto, dependent: :destroy

  accepts_nested_attributes_for :docs
  accepts_nested_attributes_for :property
  accepts_nested_attributes_for :crime
  accepts_nested_attributes_for :gl
  accepts_nested_attributes_for :auto
end
