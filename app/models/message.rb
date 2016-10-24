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
               [:stat, 'strength|dexterity|constitution|intelligence|wisdom|charisma'],
               [:stat_mod, 'str|dex|con|int|wis|cha'],
               [:equipment_mod, 'attack|defend']
             ]

  def roll_dice
    roll_params = parse_message
    mod = stat_rolls(roll_params[:stat_mod]) if roll_params[:stat_mod]
    mod = stat(roll_params[:stat]) if roll_params[:stat]
    mod = equipment_rolls(roll_params[:equipment_mod]) if roll_params[:equipment_mod]
    if self.body[/\d{1,3}d\d{1,3}/]
      roll_params = numberize_die(roll_params)
      rolls = roll(roll_params[:times_rolled],
                   roll_params[:sides_to_die])
      rolls, dropped = sorted_drop(rolls) if roll_params[:dropped_die]
      if roll_params[:attachment]
        attach = Attachment.new(roll_params[:attachment][0],
                                roll_params[:attachment][/\d{1,3}/])
        self.body = build_roll_message(rolls, attach, dropped, mod)
      else
        self.body = build_roll_message(rolls, nil, dropped, mod)
      end
    else
      self.body = build_roll_message(roll, attach, nil, mod)
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

  def stat(mod)
    actor = Actor.find_by(name: self.user_name)
    stat = actor.character.stats.find_by("name ~* ?", "#{mod}")
    [" +", stat.value]
  end

  def stat_rolls(mod)
    actor = Actor.find_by(name: self.user_name)
    stat = actor.character.stats.find_by("name ~* ?", "#{mod}")
    case stat.value
    when (1..3)   then return [" ", -3]
    when (4..5)   then return [" ", -2]
    when (6..8)   then return [" ", -1]
    when (9..12)  then return [" +", 0]
    when (13..15) then return [" +", 1]
    when (16..17) then return [" +", 2]
    when (18)     then return [" +", 3]
    end
  end

  def equipment_rolls(mod_message)
    actor = Actor.find_by(name: self.user_name)
    mod_type = "weapon" if mod_message == "attack"
    mod_type = "armor" if mod_message == "defend"
    equipment = actor.character.modifiers.find_by("name ~* ?", "#{mod_type}")
    case equipment.name
    when "weapon" then return [" +", equipment.value, mod_message]
    when "armor" then return [" ", -equipment.value, mod_message]
    end
  end

  def sorted_drop(rolls)
    rolls.sort!
    self.body[/high/] ? dropped = rolls.pop : dropped = rolls.shift
    [rolls, dropped]
  end

  def build_roll_message(rolls, attach = nil, dropped = nil, mod = nil)
    total = rolls.sum
    mods = ""
    attaches = []
    if attach
      attaches = [[attach.op, attach.mod].join, ""]
      attaches = pierce_armor(mod, attaches[0]) if mod
      total += attaches[0].to_i
    end
    if mod
      mods = mod
      total += mod[1]
    end
    "#{self.user_name} rolls #{self.body}, resulting in"\
    " *#{rolls.join(", ")}#{mod_message(mods)}#{attaches_message(attaches)}* for a total of"\
    " *#{total}*#{dropped_message(dropped)}"
  end

  def pierce_armor(mod = nil, attaches)
    if mod[2] == "defend"
      defend = mod[0..1].join
      attaches[1] = defend[2] if attaches.to_i > defend[0..1].to_i
      return [attaches, " piercing damage"]
    end
    [attaches, ""]
  end

  def attaches_message(attaches = nil)
    " #{[attaches].join("")}" if attaches.present?
  end

  def mod_message(mods = nil)
    "#{mods[0]}#{mods[1]}"
  end

  def dropped_message(dropped = nil)
    " _dropped #{dropped}_" if dropped
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end
end
