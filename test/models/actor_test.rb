require 'test_helper'

class ActorTest < ActiveSupport::TestCase
  test "check that actor exists" do
    assert_equal("mattrice", Actor.find_by(name: "mattrice").name)
    assert_equal("dane", Actor.find_by(name: "dane").name)
  end
end
