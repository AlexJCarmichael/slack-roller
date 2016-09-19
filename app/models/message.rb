require 'securerandom'
class Message < ApplicationRecord
  def roll_dice
    if self.body[/\d{1,3}d\d{1,3}/]
      num_times = self.body[/\b\d{1,3}/].to_i
      num_of_sides = self.body[/\d{1,3}\b/].to_i
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
      attachment = self.body[/(- |\+\ |\/\ |\*\ )\d*/]
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
