class Modifier < ApplicationRecord

  has_one :character_modifier
  has_one :character, through: :character_modifiers

  def self.create_modifiers(parser, character)
    stats_arr = %w(weapon_modifier armor_modifier)
    stats_arr.each do |s|
      name = s
      value = parser[s]
      mod = Modifier.new(name: name,
                         value: value)
      mod.save

      CharacterModifier.create!(modifier_id: mod.id,
                                character_id: character.id)
    end
  end
end
