require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup

    @msg = Message.new
    @msg1 = Message.new(body: "3d6", user_name: "dane")
    @msg2 = Message.new(body: "2d6 + 2", user_name: "dane")
    @msg3 = Message.new(body: "4d8 - 3", user_name: "dane")
    @msg4 = Message.new(body: "3d6 + 2 drop low", user_name: "dane")
    @msg5 = Message.new(body: "4d8 - 3 drop high", user_name: "dane")
    @msg6 = Message.new(body: "str", user_name: "dane")
    @msg7 = Message.new(body: "weapon", user_name: "dane")
    @msg8 = Message.new(body: "2d6 str", user_name: "dane")
    @msg9 = Message.new(body: "4d20 str drop high", user_name: "dane")

    @roll_params1 = { times_rolled: "2",
                      sides_to_die: "d6",
                      modifier: nil,
                      attachment: nil }
    @roll_params2 = { times_rolled: "2",
                      sides_to_die: "d6",
                      modifier: "+ 2",
                      attachment: nil }
  end

  test "message parsing with no modifiers" do
    assert_equal({ times_rolled: "3", sides_to_die: "d6", dropped_die: nil, attachment: nil, :stat=>nil, :stat_mod=>nil, :equipment_mod=>nil },
                 @msg1.parse_message)
  end

  test "message parsing with add and subtract modifiers" do
    assert_equal({ times_rolled: "2", sides_to_die: "d6", dropped_die: nil, attachment: "+ 2", :stat=>nil, :stat_mod=>nil, :equipment_mod=>nil },
                 @msg2.parse_message)
    assert_equal({ times_rolled: "4", sides_to_die: "d8", dropped_die: nil, attachment: "- 3", :stat=>nil, :stat_mod=>nil, :equipment_mod=>nil },
                 @msg3.parse_message)
  end

  test "message parsing with add and subtract modifiers with drop high and low" do
    assert_equal({ times_rolled: "3", sides_to_die: "d6", dropped_die: "drop", attachment: "+ 2", :stat=>nil, :stat_mod=>nil, :equipment_mod=>nil },
                 @msg4.parse_message)
    assert_equal({ times_rolled: "4", sides_to_die: "d8", dropped_die: "drop", attachment: "- 3", :stat=>nil, :stat_mod=>nil, :equipment_mod=>nil },
                 @msg5.parse_message)
  end

  test "message parsing with stat modifiers" do
    assert_equal({ times_rolled: nil, sides_to_die: nil, dropped_die: nil, attachment: nil, :stat=>nil, :stat_mod=>"str", :equipment_mod=>nil },
                 @msg6.parse_message)
    assert_equal({ times_rolled: nil, sides_to_die: nil, dropped_die: nil, attachment: nil, :stat=>nil, :stat_mod=>nil, :equipment_mod=>"weapon" },
                 @msg7.parse_message)
    assert_equal({ times_rolled: "2", sides_to_die: "d6", dropped_die: nil, attachment: nil, :stat=>nil, :stat_mod=>"str", :equipment_mod=>nil },
                 @msg8.parse_message)
    assert_equal({ times_rolled: "4", sides_to_die: "d20", dropped_die: "drop", attachment: nil, :stat=>nil, :stat_mod=>"str", :equipment_mod=>nil },
                 @msg9.parse_message)
  end



  test "numberize die" do
    assert_equal({ times_rolled: 2, sides_to_die: 6, modifier: nil, attachment: nil} ,
                 @msg.numberize_die(@roll_params1))
    assert_equal({ times_rolled: 2, sides_to_die: 6, modifier: "+ 2", attachment: nil} ,
                 @msg.numberize_die(@roll_params2))
  end

  test "rolling two six-sided die" do
    result = @msg.roll
    assert_equal(2, result.length)
    assert(result[0] >= 1 && result[0] <= 6)
    assert(result[1] >= 1 && result[1] <= 6)
  end

  test "rolling four eight-sided die" do
    result = @msg.roll(4, 8)
    assert_equal(4, result.length)
    assert(result[0] >= 1 && result[0] <= 8)
    assert(result[1] >= 1 && result[1] <= 8)
    assert(result[2] >= 1 && result[2] <= 8)
    assert(result[3] >= 1 && result[3] <= 8)
  end

  test "drop highest die" do
    result = @msg5.sorted_drop([3,1,6,4])
    assert(result[0] == [1,3,4])
    assert(result[0].last != 6)
    assert(result[1] == 6)

    result2 = @msg5.sorted_drop([rand(1..6),rand(1..6),rand(1..6)])
    assert(result2[0].last <= result2[1] )
  end

  test "drop lowest die" do
    result = @msg4.sorted_drop([3,1,6,4])
    assert(result[0] == [3,4,6])
    assert(result[0].first != 1)
    assert(result[1] == 1)

    result2 = @msg4.sorted_drop([rand(1..6),rand(1..6),rand(1..6)])
    assert(result2[0].first >= result2[1] )
  end

  test "building the roll message" do
    result1 = @msg1.build_roll_message([2,6,4])
    result2 = @msg2.build_roll_message([4,5], Attachment.new("+", "2"))
    result3 = @msg4.build_roll_message([5,6], Attachment.new("+", "2"), 4)
    result4 = @msg6.build_roll_message([5,6], nil, nil, [" +", 2])

    assert_equal("dane rolls 3d6, resulting in *2, 6, 4* for a total of *12*", result1)
    assert_equal("dane rolls 2d6 + 2, resulting in *4, 5* for a total of *11*", result2)
    assert_equal("dane rolls 3d6 + 2 drop low, resulting in *5, 6* for a total of *13* _dropped 4_",
                 result3)
    assert_equal("dane rolls str, resulting in *5, 6 +2* for a total of *13*", result4)
  end
end
