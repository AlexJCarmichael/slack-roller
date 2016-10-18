class CreateAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :attributes do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :strength, null: false
      t.integer :dexterity, null: false
      t.integer :constitution, null: false
      t.integer :intelligence, null: false
      t.integer :wisdom, null: false
      t.integer :charisma, null: false
      
      t.timestamps
    end
  end
end
