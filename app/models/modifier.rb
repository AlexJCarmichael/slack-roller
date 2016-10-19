class Modifier < ApplicationRecord
  belongs_to :character

  def self.create_modifiers(parser, character)
    stats_arr = %w(weapon_modifier armor_modifier)
    stats_arr.each do |s|
      modifier_name = s
      modifier_value = parser[s]
      mod = Modifier.new(character_id: character.id, modifier_name: modifier_name, modifier_value: modifier_value)
      mod.save
    end
  end
end
