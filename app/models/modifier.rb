class Modifier < ApplicationRecord

  has_one :character_modifier
  has_one :character, through: :character_modifiers



  def self.create_modifiers(parser, character)
    stats_arr = %w(weapon_modifier armor_modifier)
    stats_arr.each do |s|
      modifier_name = s
      modifier_value = parser[s]
      mod = Modifier.new(modifier_name: modifier_name, modifier_value: modifier_value)
      mod.save

      modifiable = Modifiable.new(modifier_id: mod.id, character_id: character.id)
      modifiable.save
    end
  end
end
