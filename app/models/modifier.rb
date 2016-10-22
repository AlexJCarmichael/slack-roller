class Modifier < ApplicationRecord
  has_one :character_modifier, dependent: :destroy
  has_one :character, through: :character_modifier, dependent: :destroy

  MODIFIER_ARR = %w(weapon armor)

  validates :name,  presence: true, inclusion:    { in: MODIFIER_ARR }
  validates :value, presence: true, numericality: { only_integer: true }

  def self.create_modifiers(parser, character)
    MODIFIER_ARR.each do |s|
      name = s
      value = parser[s] || 0
      value = "0" if (value.to_i == 0)

      mod = Modifier.create(name: name,
                            value: value)

      CharacterModifier.create(modifier_id: mod.id,
                               character_id: character.id)
    end
  end
end
