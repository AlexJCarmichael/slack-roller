class Character < ApplicationRecord
  belongs_to :actor

  has_many :character_stats
  has_many :stats, through: :character_stats

  has_many :character_modifiers
  has_many :modifiers, through: :character_modifiers

  # validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true

  def new_char(actor, message)
    actor = find_actor_id(actor)
    parsed_character = parse_message(message)
    character_name
    Stat.create_stats(parser, character)
    Modifier.create_modifiers(parser, character)
  end

  def parse_message(message)
    message_arr = message.split(', ')
    message_item = message_arr.map do |input|
      a = input.split(' ')
      a[0] = "\"" + a[0][0..-2] + "\"" + a[0][-1] + " \"" + a[1] + "\", "
    end
    b = message_item.join()
    c = "{" + b[0..-3] + "}"
    binding.pry
    JSON.parse c
  end

  def find_actor_id(actor)
    Actor.find_by(name: actor)
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
