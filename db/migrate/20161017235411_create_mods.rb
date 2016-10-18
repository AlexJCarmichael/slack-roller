class CreateMods < ActiveRecord::Migration[5.0]
  def change
    create_table :mods do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :weapon_mod
      t.integer :armor_mod

      t.timestamps
    end
  end
end
