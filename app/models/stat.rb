class Stat < ApplicationRecord
  has_many :statables
  has_many :characters, through: :statables


  def self.create_stats(parser, character)
    stats_arr = %w(strength dexterity constitution intelligence wisdom charisma)
    stats_arr.each do |s|
      stat_name = s
      stat_value = parser[s]
      stat = Stat.new(stat_name: stat_name, stat_value: stat_value)
      stat.save

      statable = Statable.new(stat_id: stat.id, character_id: character.id)
      statable.save
    end
  end
end
