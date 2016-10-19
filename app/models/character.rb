class Character < ApplicationRecord
  has_many :stats
  has_many :modifiers

  # validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true

  def self.create_char(parser, actor)
    character_name = parser["character_name"]
    character = Character.new(actor_id: actor.id, character_name: character_name, user_name: actor.name)
    character.save
  end


end
