class Stat < ApplicationRecord
  has_one :character_stat, dependent: :destroy
  has_one :character, through: :character_stat, dependent: :destroy

  STATS_ARR = %w(strength dexterity constitution intelligence wisdom charisma)

  validates :name,  presence: true, inclusion:    { in: STATS_ARR }
  validates :value, presence: true, numericality: { only_integer: true,
                                                    greater_than: -1,
                                                    less_than: 19}

  def self.create_stats(parser, character)
    STATS_ARR.each do |s|
      name = s
      value = parser[s] || 0
      value = "0" if (value.to_i >= 19 || value.to_i <= 0)
      stat = Stat.create(name: name,
                         value: value)

      CharacterStat.create(stat_id: stat.id,
                           character_id: character.id)
    end
  end
end
