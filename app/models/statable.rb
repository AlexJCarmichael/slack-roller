class Statable < ApplicationRecord
  belongs_to :character
  belongs_to :stat
end
