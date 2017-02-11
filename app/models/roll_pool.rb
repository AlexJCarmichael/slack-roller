class RollPool < ApplicationRecord
  belongs_to :actor
  validates :actor, uniqueness: true
end
