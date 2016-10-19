class Actor < ApplicationRecord
  has_many :characters
  has_one :actor_character

  validates :name, presence: true, uniqueness: true
end
