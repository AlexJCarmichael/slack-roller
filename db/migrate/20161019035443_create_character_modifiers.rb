class CreateCharacterModifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :character_modifiers do |t|
      t.belongs_to :character, foreign_key: true
      t.belongs_to :modifier, foreign_key: true

      t.timestamps
    end
  end
end
