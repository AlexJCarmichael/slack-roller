class Actor < ApplicationRecord
  has_many :characters

  has_one :actor_character
  has_one :character, through: :actor_character

  validates :name, presence: true, uniqueness: true


  def character_list
    return "#{name}'s characters are:\n#{characters.map { |character| character.name }.join("\n")}" if characters.present?
    "#{name} has no characters registered yet."
  end
end
