class Actor < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
