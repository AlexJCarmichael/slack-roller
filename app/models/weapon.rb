class Weapon < ApplicationRecord
  has_many :character_weapons
  has_many :characters, through: :character_weapons, dependent: :destroy

  validates :name,    presence: true, uniqueness: true

  QUALITY_ARR = %w(dull normal masterful)

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

  def new_weapon(message)
    parsed_weapon = parse_message(message)
    self.name = parsed_weapon["name"]
    self.quality = parsed_weapon["quality"] if parsed_weapon["quality"].present?
  end

  def random_weapon(message)
    self.name = "Billdaaa"
    self.quality = QUALITY_ARR.sample
  end

  def edit_weapon(message)
    parsed_weapon = parse_message(message)
    self.quality = parsed_weapon["quality"] if parsed_weapon["quality"]
  end

  def new_weapon_message(actor_name)
    return """#{quality} #{name} has just been created by #{actor_name}!""" if quality
    """#{name} has just been created by #{actor_name}!"""
  end

  def edit_weapon_message(actor_name)
    return """#{quality} #{name} has just been updated by #{actor_name}!""" if quality
    """#{name} has just been updated by #{actor_name}!"""
  end

  def weapon_name(message)
    begin
      parsed_weapon = parse_message(message)
      parsed_weapon["name"]
    rescue
      message
    end
  end

  def weapon_message
    """Weapon: #{name}"""
  end
end
