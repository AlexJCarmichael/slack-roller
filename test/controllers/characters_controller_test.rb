require 'test_helper'

class CharactersControllerTest < ActionDispatch::IntegrationTest

  test "create a simple character" do
    post new_char_path, params: { user_name: "mattrice", text: "name: SimpleChar, strength: 10" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"SimpleChar, created by mattrice, with the following stats:
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
    assert_equal ({"response_type"=>"in_channel", "text"=>"ComplexChar, created by mattrice, with the following stats:
    Strength: 16
    Dexterity: 15
    Constitution: 14
    Intelligence: 13
    Wisdom: 12
    Charisma: 11
    Weapon Modifier(s): 2
    Armor Modifier(s): 1"}), JSON.parse(@response.body)
  end

  test "display character sheet without text" do
    post character_path, params: { user_name: "mattrice", text: "" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Thūm, created by mattrice, with the following stats:
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
    assert_equal ({"response_type"=>"in_channel", "text"=>"Thūm, created by mattrice, with the following stats:
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
    assert_equal ({"response_type"=>"in_channel", "text"=>"mattrice's characters are:\nThūm\nCrank"}), JSON.parse(@response.body)
  end

  test "display actor's characters with text" do
    post characters_path, params: { user_name: "mattrice", text: "dane" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"dane's characters are:\nDanekin Skydangler"}), JSON.parse(@response.body)
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
