class CreateModifiers < ActiveRecord::Migration[5.0]
  def change
    create_table :modifiers do |t|
      t.belongs_to :character, foreign_key: true
      t.string :modifier_name
      t.integer :modifier_value

      t.timestamps
    end
  end
end
