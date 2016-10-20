require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @mattrice = Actor.find_by(name: "mattrice")
    @dane = Actor.find_by(name: "dane")
    @thumb = Character.new
    @gm = Character.create!(name: "GM", actor: @dane)
    @thum = Character.find_by(name: "Thūm")
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

  test "new_char method" do
    assert_equal("thumb", @thumb.new_char(@mattrice, "name: thumb"))
    assert_equal("luck", @thumb.new_char(@mattrice, "name: luck"))
  end

  test "parse_message method" do
    assert_equal({"name"=>"thumb"},  Character.new.parse_message("name: thumb"))
    assert_equal({"strength"=>"15"}, Character.new.parse_message("strength: 15"))
    assert_equal({"armor"=>"3"},     Character.new.parse_message("armor: 3"))
    assert_equal({"name"=>"thumb", "strength"=>"15", "armor"=>"3"}, Character.new.parse_message("name: thumb, strength: 15, armor: 3"))

    assert_equal({"name"=>"thumb"}, Character.new.parse_message("name: thumb strength: 15 armor: 3"))

    assert_equal({"name"=>"Thūm", "strength"=>"16", "dexterity"=>"15", "constitution"=>"14", "intelligence"=>"13", "wisdom"=>"12", "charisma"=>"11", "weapon"=>"2", "armor"=>"1"}, Character.new.parse_message("name: Thūm, strength: 16, dexterity: 15, constitution: 14, intelligence: 13, wisdom: 12, charisma: 11, weapon: 2, armor: 1"))
  end

  test "new_character_message method" do
    assert_equal("""#{@thum.actor.name} birthed a new character, #{@thum.name}, with the following stats:
    Strength: #{@thum.attribute_call("strength", @thum.stats)}
    Dexterity: #{@thum.attribute_call("dexterity", @thum.stats)}
    Constitution: #{@thum.attribute_call("constitution", @thum.stats)}
    Intelligence: #{@thum.attribute_call("intelligence", @thum.stats)}
    Wisdom: #{@thum.attribute_call("wisdom", @thum.stats)}
    Charisma: #{@thum.attribute_call("charisma", @thum.stats)}
    Weapon Modifier(s): #{@thum.attribute_call("weapon", @thum.modifiers)}
    Armor Modifier(s): #{@thum.attribute_call("armor", @thum.modifiers)}""", @thum.new_char_message)
  end

end
