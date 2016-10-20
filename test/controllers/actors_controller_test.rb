class ActorsControllerTest < ActionDispatch::IntegrationTest

  test "should register an actor" do
    assert_difference("Actor.count") do
      post("/register", params: { user_name: "Justin" })
    end
    response = JSON.parse(@response.body)
    assert_equal "Registered Justin as a player.",
                  response["text"]
  end

  test "should not register an existing actor" do
    assert_no_difference("Actor.count") do
      post("/register", params: { user_name: "mattrice" })
    end
    response = JSON.parse(@response.body)
    assert_equal "mattrice already exists as a player.",
                  response["text"]
  end

  test "should register a character to an existing actor" do
    post register_character_path, params: { user_name: "mattrice", text: "Thūm" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"mattrice is now using Thūm."}), JSON.parse(@response.body)
  end

  test "should not register a non-existing character to an existing actor" do
    post register_character_path, params: { user_name: "mattrice", text: "Gerald" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"Gerald is not a character for mattrice."}), JSON.parse(@response.body)
  end

  test "should not register a character to a non-existing actor" do
    post register_character_path, params: { user_name: "Justin", text: "Thūm" }
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"You are not registered. To register, type `/register`."}), JSON.parse(@response.body)
  end

  test "should delete an ActorCharacter when it creates a new one" do
    assert_no_difference("ActorCharacter.count") do
      post("/register_character", params: { user_name: "mattrice", text: "Crank" })
    end
    response = JSON.parse(@response.body)
    assert_equal "mattrice is now using Crank.",
                  response["text"]
  end

  test "should display a list of all actors" do
    post roster_path
    assert_response :success
    assert_equal ({"response_type"=>"in_channel", "text"=>"mattrice\ndane"}), JSON.parse(@response.body)
  end
end
