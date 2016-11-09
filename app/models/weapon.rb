class Weapon < ApplicationRecord
  has_many :character_weapons

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
  end

  def new_weapon_message(actor_name)
    """#{name} has just been created by #{actor_name}!"""
  end

  def find_weapon(message)
    parsed_weapon = parse_message(message)
    parsed_weapon["name"]
  end

  def weapon_message
    """This is #{name}"""
  end
end
