class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :character_name, null: false

      t.timestamps
    end
  end
end
