class CharacterStat < ApplicationRecord
  belongs_to :character
  belongs_to :stat
end
