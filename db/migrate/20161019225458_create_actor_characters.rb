class CreateActorCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :actor_characters do |t|
      t.belongs_to :character, foreign_key: true
      t.belongs_to :actor, foreign_key: true

      t.timestamps
    end
  end
end
