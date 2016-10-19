class ActorControllerTest < ActionController::TestCase
  
  test "should register an actor" do
    assert_difference("Actor.count") do
      post(:register, actor: { name: "dane" })
    end
    response = JSON.parse(@response.body)
    assert_equal "Registered dane as a player.",
                  response["text"]
  end
end
