class Modifier < ApplicationRecord

  has_one :character_modifier
  has_one :character, through: :character_modifiers

  MODIFIER_ARR = %w(weapon armor)

  validates :name, presence: true, inclusion: { in: MODIFIER_ARR }
  validates :value, presence: true, numericality: { only_integer: true }


  def self.create_modifiers(parser, character)
    MODIFIER_ARR.each do |s|
      name = s
      value = parser[s]
      value = 0 if value == nil
      mod = Modifier.create(name: name,
                            value: value)

      CharacterModifier.create(modifier_id: mod.id,
                               character_id: character.id)
    end
  end
end
