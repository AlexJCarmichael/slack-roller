class Actor < ApplicationRecord
  has_many :characters, dependent: :destroy

  has_one :actor_character, dependent: :destroy
  has_one :character, through: :actor_character, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def character_list
    return "#{name}'s characters are:\n\t#{characters.map { |character| character.name }.join("\n\t")}" if characters.present?
    "#{name} has no characters registered yet."
  end

end
