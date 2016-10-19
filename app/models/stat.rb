class Stat < ApplicationRecord
  belongs_to :character

  def create_attributes(parser, character)
    self.character_id = character.id
    self.stat_name = parser["strength"]
    self.stat_value = parser[""]
    self.save
  end
end
