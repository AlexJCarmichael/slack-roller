class Character < ApplicationRecord
  has_many :stats
  has_many :modifiers

  # validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true

  def self.create_char(parser, user_name)
    character_name = parser["character_name"]
    character = Character.new(character_name: character_name, user_name: user_name)
    character.save
  end


end
