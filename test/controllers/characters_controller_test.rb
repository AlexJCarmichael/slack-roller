require 'test_helper'

class CharactersControllerTest < ActionDispatch::IntegrationTest

  test "create a simple character" do
    post new_char_path, params: { user_name: "mattrice", text: "name: SimpleChar, strength: 10" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"SimpleChar has just been created by mattrice! SimpleChar has the following stats:
    Name: SimpleChar
    Strength: 10
    Dexterity: 0
    Constitution: 0
    Intelligence: 0
    Wisdom: 0
    Charisma: 0
    Weapon Modifier(s): 0
    Armor Modifier(s): 0"}), JSON.parse(@response.body)
  end

  test "create a full character" do
    post new_char_path, params: { user_name: "mattrice", text: "name: ComplexChar, strength: 16, dexterity: 15, constitution: 14, intelligence: 13, wisdom: 12, charisma: 11, weapon: 2, armor: 1" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"ComplexChar has just been created by mattrice! ComplexChar has the following stats:
    Name: ComplexChar
    Strength: 16
    Dexterity: 15
    Constitution: 14
    Intelligence: 13
    Wisdom: 12
    Charisma: 11
    Weapon Modifier(s): 2
    Armor Modifier(s): 1"}), JSON.parse(@response.body)
  end

  test "edit a full character" do
    post edit_char_path, params: { user_name: "mattrice", text: "name: Jimbo, strength: 5, dexterity: 6, constitution: 7, intelligence: 8, wisdom: 9, charisma: 10, weapon: 11, armor: 12" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"mattrice has updated his character:
    Name: Jimbo
    Strength: 5
    Dexterity: 6
    Constitution: 7
    Intelligence: 8
    Wisdom: 9
    Charisma: 10
    Weapon Modifier(s): 11
    Armor Modifier(s): 12"}), JSON.parse(@response.body)
  end

  test "display character sheet without text" do
    post character_path, params: { user_name: "mattrice", text: "" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"    Name: Thūm
    Strength: 16
    Dexterity: 15
    Constitution: 14
    Intelligence: 13
    Wisdom: 12
    Charisma: 11
    Weapon Modifier(s): 2
    Armor Modifier(s): 1"}), JSON.parse(@response.body)
  end

  test "display character sheet with text" do
    post character_path, params: { user_name: "mattrice", text: "Thūm" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"    Name: Thūm
    Strength: 16
    Dexterity: 15
    Constitution: 14
    Intelligence: 13
    Wisdom: 12
    Charisma: 11
    Weapon Modifier(s): 2
    Armor Modifier(s): 1"}), JSON.parse(@response.body)
  end

  test "display character sheet with invalid text" do
    post character_path, params: { user_name: "mattrice", text: "Banana" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Invalid input. Make sure you spelled the character's name correctly."}), JSON.parse(@response.body)
  end

  test "display actor's characters without text" do
    post characters_path, params: { user_name: "mattrice", text: "" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"mattrice's characters are:\n\tThūm\n\tCrank"}), JSON.parse(@response.body)
  end

  test "display actor's characters with text" do
    post characters_path, params: { user_name: "mattrice", text: "dane" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"dane's characters are:\n\tDanekin Skydangler"}), JSON.parse(@response.body)
  end

  test "display actor's characters with invalid text" do
    post characters_path, params: { user_name: "mattrice", text: "Banana" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Invalid input. Make sure you spelled the user's name correctly."}), JSON.parse(@response.body)
  end

  test "should display a list of all characters" do
    post character_roster_path
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Thūm\nCrank\nDanekin Skydangler"}), JSON.parse(@response.body)
  end
end
