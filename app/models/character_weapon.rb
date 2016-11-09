class CharacterWeapon < ApplicationRecord
  belongs_to :character
  belongs_to :weapon
end
