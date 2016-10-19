class Character < ApplicationRecord
  has_many :stats
  has_many :modifiers

  # validates :char_name, presence: true, length: { maximum: 128}, uniqueness: true

  def create_char(parser, user_name)
    self.user_name = user_name
    self.character_name = parser["character_name"]
    self.save
  end


end
