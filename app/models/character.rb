class Character < ApplicationRecord
  belongs_to :actor

  has_many :statables
  has_many :stats, through: :statables

  has_many :modifiables
  has_many :modifiers, through: :modifiables

  # validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true

  def self.create_char(parser, actor)
    character_name = parser["character_name"]
    character = Character.new(actor_id: actor.id, character_name: character_name, user_name: actor.name)
    character.save
  end


end
