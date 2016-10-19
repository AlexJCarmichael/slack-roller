class Stat < ApplicationRecord
  has_one :character_stat
  has_one :character, through: :character_stats

  def self.create_stats(parser, character)
    stats_arr = %w(strength dexterity constitution intelligence wisdom charisma)
    stats_arr.each do |s|
      name = s
      value = parser[s]
      stat = Stat.new(name: name,
                      value: value)
      stat.save

      char_stat = CharacterStat.new(stat_id: stat.id,
                                    character_id: character.id)
      char_stat.save
    end
  end
end
