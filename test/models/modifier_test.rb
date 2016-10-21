require 'test_helper'

class ModifierTest < ActiveSupport::TestCase
  def setup
    @mattrice = Actor.find_by(name: "mattrice")
    @dane =     Actor.find_by(name: "dane")
    @thum =     Character.find_by(name: "Thūm")
    @danekin =  Character.find_by(name: "Danekin-Skydangler")
  end

  test "modifier exists" do
    assert_equal("weapon", Modifier.find_by(name: "weapon").name)
    assert_equal(2,        Modifier.find_by(name: "weapon").value)

    assert_equal("armor",  Modifier.find_by(name: "armor").name)
    assert_equal(1,        Modifier.find_by(name: "armor").value)
  end

  test "modifier through character" do
    assert_equal("weapon", @thum.modifiers.find_by(name: "weapon").name)
    assert_equal(2,        @thum.modifiers.find_by(name: "weapon").value)

    assert_equal("armor",  @danekin.modifiers.find_by(name: "armor").name)
    assert_equal(999,      @danekin.modifiers.find_by(name: "armor").value)
  end

  test "modifier through actor" do
    assert_equal("weapon", @mattrice.characters.first.modifiers.find_by(name: "weapon").name)
    assert_equal(2,        @mattrice.characters.first.modifiers.find_by(name: "weapon").value)

    assert_equal("armor",  @dane.characters.first.modifiers.find_by(name: "armor").name)
    assert_equal(999,      @dane.characters.first.modifiers.find_by(name: "armor").value)
  end

  test "character through modifier" do
    assert_equal("Thūm",   Modifier.find_by(value: 2).character.name)
  end

  test "actor through modifier" do
    assert_equal("dane",   Modifier.find_by(value: 25).character.actor.name)
  end

  test "create new modifier" do
    assert_equal("armor", Modifier.create!(name: "armor",  value: 2).name)
    assert_equal(1,       Modifier.create!(name: "weapon", value: 1).value)
    assert_equal(0,       Modifier.create!(name: "armor").value)
    assert_equal(0,       Modifier.create!(name: "weapon").value)
  end

  test "validations" do
    assert_raises("Name can't be blank, Name is not included in the list"){ Modifier.create!() }
    assert_raises("Name can't be blank, Name is not included in the list"){ Modifier.create!(value: 14) }
    assert_raises("Name is not included in the list"){ Modifier.create!(name: "Wepun", value: 14) }
  end

end
