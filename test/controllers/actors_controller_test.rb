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

end
