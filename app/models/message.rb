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
               [:attachment, '([-\+\*\\/] ?)\d*'],
               [:stat_mod, 'str|dex|con|int|wis|cha']
             ]

  def roll_dice
    roll_params = parse_message
    stat_mod = mod_rolls(roll_params[:stat_mod]) if roll_params[:stat_mod]
    if self.body[/\d{1,3}d\d{1,3}/]
      roll_params = numberize_die(roll_params)
      rolls = roll(roll_params[:times_rolled],
                   roll_params[:sides_to_die])
      rolls, dropped = sorted_drop(rolls) if roll_params[:dropped_die]
      if roll_params[:attachment]
        attach = Attachment.new(roll_params[:attachment][0],
                                roll_params[:attachment][/\d{1,3}/])
        self.body = build_roll_message(rolls, attach, dropped, stat_mod)
      else
        self.body = build_roll_message(rolls, nil, dropped, stat_mod)
      end
    else
      self.body = build_roll_message(roll, nil, nil, stat_mod)
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

  def mod_rolls(mod)
    actor = Actor.find_by(name: self.user_name)
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts mod
    puts "??????????????????????????????????"
    stat = actor.character.stats.find_by("name ~* ?", "#{mod}")
    case stat.value
    when (1..3)   then return [" ", -3]
    when (4..5)   then return [" ", -2]
    when (6..8)   then return [" ", -1]
    when (9..12)  then return [" ", 0]
    when (13..15) then return [" +", 1]
    when (16..17) then return [" +", 2]
    when (18)     then return [" +", 3]
    end
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

  def build_roll_message(rolls, attach = nil, dropped = nil, stat_mod = nil)
    total = rolls.sum
    total = total.public_send(attach.op, attach.mod) if attach
    mods = ""
    if stat_mod
      total += stat_mod[1]
      mods = stat_mod
    end
    "#{self.user_name} rolls #{self.body}, resulting in"\
    " *#{rolls.join(", ")}*#{mods[0]}#{mods[1]} for a total of"\
    " *#{total}*#{dropped_message(dropped)}"
  end

  def dropped_message(dropped = nil)
    " _dropped #{dropped}_" if dropped
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end
end
