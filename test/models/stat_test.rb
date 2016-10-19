require 'test_helper'

class StatTest < ActiveSupport::TestCase
  def setup
    @mattrice = Actor.find_by(name: "mattrice")
    @dane =     Actor.find_by(name: "dane")
    @thum =     Character.find_by(name: "Thūm")
    @danekin =  Character.find_by(name: "Danekin Skydangler")
  end

  test "modifier exists" do
    assert_equal("strength", Stat.find_by(name: "strength").name)
    assert_equal(16,         Stat.find_by(name: "strength").value)

    assert_equal("dexterity", Stat.find_by(name: "dexterity").name)
    assert_equal(15,          Stat.find_by(name: "dexterity").value)
  end

  test "modifier through character" do
    assert_equal("constitution", @thum.stats.find_by(name: "constitution").name)
    assert_equal(14,             @thum.stats.find_by(name: "constitution").value)

    assert_equal("intelligence", @danekin.stats.find_by(name: "intelligence").name)
    assert_equal(13,             @danekin.stats.find_by(name: "intelligence").value)
  end

  test "modifier through actor" do
    assert_equal("wisdom", @mattrice.characters.first.stats.find_by(name: "wisdom").name)
    assert_equal(12,       @mattrice.characters.first.stats.find_by(name: "wisdom").value)

    assert_equal("charisma", @dane.characters.first.stats.find_by(name: "charisma").name)
    assert_equal(11,         @dane.characters.first.stats.find_by(name: "charisma").value)
  end
end
