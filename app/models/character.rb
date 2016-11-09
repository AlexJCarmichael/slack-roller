class Character < ApplicationRecord
  belongs_to :actor

  has_one :actor_character, dependent: :destroy

  has_many :character_stats, dependent: :destroy
  has_many :stats, through: :character_stats, dependent: :destroy
  has_many :character_modifiers, dependent: :destroy
  has_many :modifiers, through: :character_modifiers, dependent: :destroy
  has_one  :character_weapon, dependent: :destroy
  has_one  :weapon, through: :character_weapon


  validates :name, presence: true, uniqueness: true

  STATS_ARR = %w(strength dexterity constitution intelligence wisdom charisma)
  MODIFIER_ARR = %w(weapon armor)

  def new_char(actor_name, message)
    parsed_character = parse_message(message)

    self.actor = find_actor_id(actor_name)
    self.name = parsed_character["name"]
  end

  def edit_char(actor_name, message)
    parsed_character = parse_message(message)
    self.name = parsed_character["name"] if parsed_character["name"]
    STATS_ARR.each do |stat|
      self.stats.find_by(name: stat).update(value: parsed_character[stat]) if parsed_character[stat]
    end
    MODIFIER_ARR.each do |mod|
      self.modifiers.find_by(name: mod).update(value: parsed_character[mod]) if parsed_character[mod]
    end
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

  def new_character_message
    """#{name} has just been created by #{actor.name}! #{name} has the following stats:\n#{character_sheet}"""
  end

  def edit_character_message
    """#{actor.name} has updated his character:\n#{character_sheet}"""
  end

  def character_sheet
    """    Name: #{actor.character.name}
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
