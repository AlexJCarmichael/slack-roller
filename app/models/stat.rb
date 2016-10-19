class Stat < ApplicationRecord
  belongs_to :character

  def self.create_stats(parser, character)
    stats_arr = %w(strength dexterity constitution intelligence wisdom charisma)
    stats_arr.each do |s|
      stat_name = s
      stat_value = parser[s]
      stat = Stat.new(character_id: character.id, stat_name: stat_name, stat_value: stat_value)
      stat.save
    end
  end
end
