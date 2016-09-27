require 'securerandom'
class Attachment < Struct.new(:operator, :modifier)

  def op
    self.operator.to_sym
  end

  def mod
    self.modifier.to_i
  end
end

class Message < ApplicationRecord

  MODIFIERS = [
               [:times_rolled, '\b\d{1,3}'],
               [:sides_to_die, 'd\d*'],
               [:dropped_die, 'drop'],
               [:attachment, '([-\+\*\\/] ?)\d*']
             ]

  def roll_dice
    if self.body[/\d{1,3}d\d{1,3}/]
      roll_params = parse_message
      roll_params = numberize_die(roll_params)
      rolls = roll(roll_params[:times_rolled],
                   roll_params[:sides_to_die])
      rolls, dropped = sorted_drop(rolls) if roll_params[:dropped_die]
      if roll_params[:attachment]
        attach = Attachment.new(roll_params[:attachment][0],
                                roll_params[:attachment][/\d{1,3}/])
        self.body = build_roll_message(rolls, attach, dropped)
      else
        self.body = build_roll_message(rolls, nil, dropped)
      end
    else
      self.body = build_roll_message(roll)
    end
  end

  def parse_message
    Hash[MODIFIERS.map do |value, reg_ex|
      [ value, self.body[Regexp.new reg_ex] ]
    end]
  end

  def numberize_die(roll_params)
    roll_params[:times_rolled] = roll_params[:times_rolled].to_i
    roll_params[:sides_to_die] = roll_params[:sides_to_die][/\d{1,3}/].to_i
    return roll_params
  end

  def roll(num_times = 2, sides = 6)
    num_times.times.collect { return_die_result(sides) }
  end

  def sorted_drop(rolls)
    rolls.sort!
    if self.body.downcase[/high/]
      dropped = rolls.pop
    else
      dropped = rolls.shift
    end
    [rolls, dropped]
  end

  def build_roll_message(rolls, attach = nil, dropped = nil)
    total = rolls.sum
    if attach
      total = total.public_send(attach.op, attach.mod)
    end
    "#{self.user_name} rolls #{self.body}, resulting in"\
    " *#{rolls.join(", ")}* for a total of"\
    " *#{total}* #{dropped_message(dropped)}"
  end

  def dropped_message(dropped = nil)
    " _dropped #{dropped}_" if dropped
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end
end
