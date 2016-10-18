class Modifier < ApplicationRecord
  belongs_to :character

  def create_modifiers(parser, character)
    self.character_id = character.id
    self.weapon_modifier = parser["weapon_modifier"]
    self.armor_modifier = parser["armor_modifier"]
    self.save
  end
end
