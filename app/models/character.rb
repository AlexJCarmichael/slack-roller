class Character < ApplicationRecord
  has_many :stats
  has_many :mods

  validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true
end
