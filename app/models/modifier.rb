class Modifier < ApplicationRecord
  belongs_to :character

  def create_modifiers(parser, character)
    self.character_id = character.id
    self.modifier_name = parser["weapon_modifier"]
    self.modifier_value = parser[""]
    self.save
  end
end
