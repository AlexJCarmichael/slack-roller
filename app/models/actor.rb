class Actor < ApplicationRecord
  has_many :characters, dependent: :destroy

  has_one :actor_character, dependent: :destroy
  has_one :character, through: :actor_character, dependent: :destroy

  has_one :roll_pool, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def character_list
    return "#{name}'s characters are:\n\t#{characters.map { |character| character.name }.join("\n\t")}" if characters.present?
    "#{name} has no characters registered yet."
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

  def self.find_char(message)
    begin
      parsed_message = Actor.new.parse_message(message)
      parsed_message["name"]
    rescue
      message
    end
  end

  def actor_name(message)
    begin
      parsed_actor = parse_message(message)
      parsed_actor["name"]
    rescue
      message
    end
  end
end
