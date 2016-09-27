require 'securerandom'
class Message < ApplicationRecord

  MODIFIERS = [
               [:times_rolled, '\b\d{1,3}'],
               [:sides_to_die, 'd\d*'],
               [:dropped_die, 'drop'],
               [:attachment, '(- |\+\ |\/\ |\*\ )\d*']
             ]

  def roll_dice
    if self.body[/\d{1,3}d\d{1,3}/]
      roll_params = parse_message
      roll_params = numberize_die(roll_params)
      binding.pry
      rolls = roll(num_times, num_of_sides)
      if self.body[/drop/]
        sorted = rolls.sort
        if self.body[/High/] || self.body[/high/]
          dropped = sorted.pop
        elsif self.body[/Low/] || self.body[/low/]
          dropped = sorted.shift
        end
      end
      original = self.body
      rolls = sorted || rolls
      if attachment
        opperator = attachment[0]
        modifier = attachment[/\d{1,3}/]
        original.gsub!(/(- |\+\ |\/\ |\*\ )\d*/, "#{opperator} #{modifier}")
        self.body = "#{self.user_name} rolls #{original}, resulting in"\
                    " *#{rolls.join(", ")}* for a total of"\
                    " *#{rolls.reduce(:+).send(opperator.to_sym, modifier.to_i)}*"\
                    + dropped_message(dropped)
      else
        self.body = "#{self.user_name} rolls #{original}, resulting in"\
                    " *#{rolls.join(", ")}* for a total of *#{rolls.reduce(:+)}*"\
                    + dropped_message(dropped)
      end
    else
      rolls = roll
      self.body = "#{self.user_name} rolls two six-sided die resulting in *#{rolls.join(", ")}*"\
                  " for a total of *#{rolls.reduce(:+)}*"
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

  def dropped_message(dropped = nil)
    if dropped
      " _dropped #{dropped}_"
    else
      ""
    end
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end
end
