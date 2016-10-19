class Character < ApplicationRecord
  belongs_to :actor

  has_many :character_stats
  has_many :stats, through: :character_stats

  has_many :character_modifiers
  has_many :modifiers, through: :character_modifiers

  validates :name, presence: true, uniqueness: true

  def new_char(actor_name, message)
    parsed_character = parse_message(message)

    self.actor = find_actor_id(actor_name)
    self.name = parsed_character["name"]
  end

  def roll_character(message)
    parsed_character = parse_message(message)
    Stat.create_stats(parsed_character, self)
    Modifier.create_modifiers(parsed_character, self)
  end

  def parse_message(message)
    message_arr = message.split(', ')
    message_item = message_arr.map do |input|
      a = input.split(' ')
      a[0] = "\"" + a[0][0..-2] + "\"" + a[0][-1] + " \"" + a[1] + "\", "
    end
    b = message_item.join()
    c = "{" + b[0..-3] + "}"
    JSON.parse c
  end

  def find_actor_id(actor)
    Actor.find_by(name: actor)
  end

  def new_char_message
    """#{actor.name} birthed a new character, #{name}, with the following stats:
    Strength: #{attribute_call("strength", stats)}
    Dexterity: #{attribute_call("dexterity", stats)}
    Constitution: #{attribute_call("constitution", stats)}
    Intelligence: #{attribute_call("intelligence", stats)}
    Wisdom: #{attribute_call("wisdom", stats)}
    Charisma: #{attribute_call("charisma", stats)}
    Weapon Modifier(s): #{attribute_call("weapon", modifiers)}
    Armor Modifier(s): #{attribute_call("armor", modifiers)}"""
  end

  def attribute_call(name, obj)
    if obj.find_by(name: name).value != nil
      obj.find_by(name: name).value
    end
  end
end
