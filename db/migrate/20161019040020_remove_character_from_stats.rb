class RemoveCharacterFromStats < ActiveRecord::Migration[5.0]
  def change
    remove_reference :stats, :character, foreign_key: true
  end
end
