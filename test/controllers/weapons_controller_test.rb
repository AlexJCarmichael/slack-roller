require 'test_helper'

class WeaponsControllerTest < ActionDispatch::IntegrationTest

### /new_weapon
  test "create a new weapon" do
    post new_weapon_path, params: { user_name: "mattrice", text: "name: hammer" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"hammer has just been created by mattrice!"}), JSON.parse(@response.body)
  end

  test "cannot create a weapon that already exists" do
    post new_weapon_path, params: { user_name: "mattrice", text: "name: sword" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Name has already been taken."}), JSON.parse(@response.body)
  end

  test "Invalid Input while creating a weapon" do
    post new_weapon_path, params: { user_name: "mattrice", text: "this text won't work" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Invalid Input. Type `/new_weapon name: <weapon_name>, quality: <quality>`"}), JSON.parse(@response.body)
  end

### /edit_weapon
  test "edit a weapon that exists" do
    post edit_weapon_path, params: { user_name: "mattrice", text: "name: sword, quality: dull" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"dull sword has just been updated by mattrice!"}), JSON.parse(@response.body)
  end

  test "edit a weapon's name that exists" do
    post edit_weapon_path, params: { user_name: "mattrice", text: "sword, name: axe, quality: dull" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"dull axe has just been updated by mattrice!"}), JSON.parse(@response.body)
  end

  test "cannot edit a weapon that doesn't exists" do
    post edit_weapon_path, params: { user_name: "mattrice", text: "name: hammer, quality: dull" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"}), JSON.parse(@response.body)
  end

  test "cannot edit a weapon that doesn't exists; not using 'name:'" do
    post edit_weapon_path, params: { user_name: "mattrice", text: "dagger" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"}), JSON.parse(@response.body)
  end

### /weapons
  test "View all weapons" do
    post weapons_path, params: { user_name: "mattrice", text: "" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"sword\naxe"}), JSON.parse(@response.body)
  end


### /weapon
  test "View specific weapon" do
    post weapon_path, params: { user_name: "mattrice", text: "name: sword" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Weapon: sword"}), JSON.parse(@response.body)
  end

  test "View specific weapon without 'name:'" do
    post weapon_path, params: { user_name: "mattrice", text: "sword" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Weapon: sword"}), JSON.parse(@response.body)
  end

  test "View specific weapon that doesn't exist" do
    post weapon_path, params: { user_name: "mattrice", text: "name: hammer" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"}), JSON.parse(@response.body)
  end

  test "Cannot view specific weapon without 'name:' in front of it if weapon doesn't exist" do
    post weapon_path, params: { user_name: "mattrice", text: "nam" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"This weapon does not exist yet. Try creating it with `/new_weapon name: <weapon_name>`"}), JSON.parse(@response.body)
  end
end
