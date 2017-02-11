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

  def parse_message
    Hash[MODIFIERS.map do |value, reg_ex|
     [ value, self.body[Regexp.new reg_ex] ]
    end]
  end

  def roll_dice
    roll_params = numberize_die(parse_message)
    rolls, attach, dropped, mod = argument_definer(roll_params)
    self.body = build_roll_message(rolls, attach, dropped, mod)
  end

  def numberize_die(parse_message)
    roll_params = parse_message
    if self.body[/\d{1,3}d\d{1,3}/]
      roll_params[:times_rolled] = roll_params[:times_rolled].to_i
      roll_params[:sides_to_die] = roll_params[:sides_to_die][/\d{1,3}/].to_i
    else
      roll_params[:times_rolled] = 2
      roll_params[:sides_to_die] = 6
    end
    return roll_params
  end

  def argument_definer(roll_params)
    rolls = dice(roll_params[:times_rolled], roll_params[:sides_to_die])
    rough_rolls(rolls)
    attach = Attachment.new(roll_params[:attachment][0], roll_params[:attachment][/\d{1,3}/]) if roll_params[:attachment]
    rolls, dropped = sorted_drop(rolls) if roll_params[:dropped_die]
    mod = mod_definer(roll_params)
    [rolls, attach, dropped, mod]
  end

  def dice(num_times = 2, sides = 6)
    num_times.times.collect { return_die_result(sides) }
  end

  def return_die_result(sides)
    SecureRandom.random_number(1..sides)
  end

  def mod_definer(roll_params)
    return stat(roll_params[:stat]) if roll_params[:stat]
    return stat_rolls(roll_params[:stat_mod]) if roll_params[:stat_mod]
    battle_rolls(roll_params[:equipment_mod]) if roll_params[:equipment_mod]
  end

  def find_actor
    Actor.find_by(name: self.user_name)
  end

  def stat(mod)
    stat = find_actor.character.stats.find_by("name ~* ?", "#{mod}")
    [" +", stat.value]
  end

  def stat_rolls(mod)
    stat = find_actor.character.stats.find_by("name ~* ?", "#{mod}")
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

  def battle_rolls(mod)
    mod_type = "weapon" if mod == "attack"
    mod_type = "armor" if mod == "defend"
    equipment = find_actor.character.modifiers.find_by("name ~* ?", "#{mod_type}")
    case equipment.name
    when "weapon" then return [" +", equipment.value, mod]
    when "armor" then return [" ", -equipment.value, mod]
    end
  end

  def sorted_drop(rolls)
    rolls.sort!
    self.body[/high/] ? dropped = rolls.pop : dropped = rolls.shift
    [rolls, dropped]
  end

  def build_roll_message(rolls = nil, attach = nil, dropped = nil, mod = nil)
    mod.present? ? mod = mod : mod = ""
    attach.present? ? attachments = attachment_definer(attach, mod) : attachments = []
    total = rolls.sum
    total += attachments[0].to_i
    total += mod[1].to_i
    finalized_rolls(rolls)
    message_output(rolls, mod, attachments, total, dropped)
  end

  def rough_rolls(rolls)
    rolls
  end

  def message_output(rolls, mod, attachments, total, dropped)
    "#{self.user_name} rolls #{self.body}, resulting in"\
    " *#{rolls.join(", ")}#{mod_message(mod)}#{attachments_message(attachments)}* for a total of"\
    " *#{total}*#{dropped_message(dropped)}"
  end

  def attachment_definer(attach, mod)
    attachments = [[attach.op, attach.mod].join, ""]
    attachments = pierce_armor(mod, attachments[0]) if mod
  end

  def pierce_armor(mod, attachments)
    if mod[2] == "defend"
      defend = mod[0..1].join
      attachments[1] = defend[2] if attachments.to_i > defend[0..1].to_i
      return [attachments, "(piercing)"]
    end
    [attachments, ""]
  end

  def attachments_message(attachments = nil)
    " #{[attachments].join("")}" if attachments.present?
  end

  def mod_message(mod)
    "#{mod[0]}#{mod[1]}"
  end

  def dropped_message(dropped = nil)
    " _dropped #{dropped}_" if dropped
  end
end
