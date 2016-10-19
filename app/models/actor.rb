class Actor < ApplicationRecord
  has_many :characters

  validates :name, presence: true, uniqueness: true
end
