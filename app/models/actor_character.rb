class ActorCharacter < ApplicationRecord
  belongs_to :character
  belongs_to :actor
end
