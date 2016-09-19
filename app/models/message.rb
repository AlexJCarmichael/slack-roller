require 'securerandom'
class Message < ApplicationRecord
  def roll_dice
    if self.body[/\d{1,3}d\d{1,3}/]
      num_times = self.body[/\b\d{1,3}/].to_i
      num_of_sides = self.body[/\d{1,3}\b/].to_i
      original = self.body
      attachment = self.body[/(- |\+\ |\/\ |\*\ )\d*/]
      if attachment
        opperator = attachment[0]
        modifier = attachment[/\d{1,3}/]
        original.gsub!(/(- |\+\ |\/\ |\*\ )\d*/, "#{opperator} #{modifier}")
        rolls = num_times.times.collect { return_die_result(num_of_sides) }
        self.body = "#{self.user_name} rolls #{original}, resulting in"\
                    " *#{rolls.join(", ")}* for a total of"\
                    "*#{rolls.reduce(:+).send(opperator.to_sym, modifier.to_i)}*"
      else
        rolls = num_times.times.collect { return_die_result(num_of_sides) }
        self.body = "#{self.user_name} rolls #{original}, resulting in"\
                    " *#{rolls.join(", ")}* for a total of *#{rolls.reduce(:+)}*"
      end
    else
      rolls = 2.times.collect { return_die_result(6) }
      self.body = "#{self.user_name} rolls two six-sided die resulting in *#{rolls.join(", ")}*"\
                  " for a total of *#{rolls.reduce(:+)}*"
    end
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end
end

# modifier and drop lowest or higher
