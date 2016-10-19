require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @actor = Actor.new(name: "mattrice")
    Character.new(name: "Thūm", actor_id: @actor)
  end
end
