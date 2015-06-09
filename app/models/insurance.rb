class Insurance < ActiveRecord::Base
  # Associations
  belongs_to :broker
  has_many :docs

  accepts_nested_attributes_for :docs
end
