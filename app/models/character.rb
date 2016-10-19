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

    Stat.create_stats(parser, character)
    Modifier.create_modifiers(parser, character)
  end

  def self.parse_new_character(body)
    body_arr = body.split(', ')
    body_item = body_arr.map do |input|
      a = input.split(' ')
      a[0] = "\"" + a[0][0..-2] + "\"" + a[0][-1] + " \"" + a[1] + "\", "
    end
    b = body_item.join()
    c = "{" + b[0..-3] + "}"
    JSON.parse c
  end

  def self.new_char_message(body, user_name)
    """#{user_name} birthed a new character, #{parse_new_character(body)["character_name"]}, with the following stats:
    Strength: #{parse_new_character(body)["strength"]}
    Dexterity: #{parse_new_character(body)["dexterity"]}
    Constitution: #{parse_new_character(body)["constitution"]}
    Intelligence: #{parse_new_character(body)["intelligence"]}
    Wisdom: #{parse_new_character(body)["wisdom"]}
    Charisma: #{parse_new_character(body)["charisma"]}
    Weapon Modifier(s): #{parse_new_character(body)["weapon_modifier"]}
    Armor Modifier(s): #{parse_new_character(body)["armor_modifier"]}"""
  end

end
