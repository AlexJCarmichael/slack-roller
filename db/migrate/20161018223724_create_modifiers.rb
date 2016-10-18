class CreateModifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :modifiers do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :weapon_modifier
      t.integer :armor_modifier
      
      t.timestamps
    end
  end
end
