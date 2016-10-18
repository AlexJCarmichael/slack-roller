class Attribute < ApplicationRecord
  belongs_to :character

  def create_attributes(parser, character)
    self.character_id = character.id
    self.strength = parser["strength"]
    self.dexterity = parser["dexterity"]
    self.constitution = parser["constitution"]
    self.intelligence = parser["intelligence"]
    self.wisdom = parser["wisdom"]
    self.charisma = parser["charisma"]
    self.save
  end
end
