class CharacterModifier < ApplicationRecord
  belongs_to :character
  belongs_to :modifier
end
