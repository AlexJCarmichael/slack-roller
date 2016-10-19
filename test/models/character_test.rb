require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @mattrice = Actor.find_by(name: "mattrice")
    @dane = Actor.find_by(name: "dane")
  end

  test "character exists" do
    assert_equal("Thūm", Character.find_by(name: "Thūm").name)
    assert_equal("Danekin Skydangler", Character.find_by(name: "Danekin Skydangler").name)
  end

  test "find character through actor" do
    assert_equal("Thūm", Actor.find_by(name: "mattrice").characters.first.name)
    assert_equal("Danekin Skydangler", Actor.find_by(name: "dane").characters.first.name)
  end

  test "create new character" do
    assert_equal("Jaba", Character.create!(name: "Jaba", actor_id: @mattrice.id).name)
    assert_equal("mattrice", Character.create!(name: "Jawa", actor_id: @mattrice.id).actor.name)

    assert_equal("Naba", Character.create!(name: "Naba", actor_id: @mattrice.id).name)
    assert_equal("dane", Character.create!(name: "Nawa", actor_id: @dane.id).actor.name)
  end

  test "validations" do
    assert_raises("Validation failed: Actor must exist, Name can't be blank"){ Character.create!() }
    assert_raises("Validation failed: Actor must exist"){ Character.create!(name: "Dave") }
    assert_raises("Validation failed: Name can't be blank"){ Character.create!(actor_id: @mattrice.id) }
    assert_raises("Validation failed: Name has already been taken"){ Character.create!(name: "Thūm", actor_id: @mattrice.id) }
  end
end
