class CreateModifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :modifiers do |t|
      t.belongs_to :character, foreign_key: true
      t.string :name
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
