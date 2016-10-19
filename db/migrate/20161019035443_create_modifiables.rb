class CreateModifiables < ActiveRecord::Migration[5.0]
  def change
    create_table :modifiables do |t|
      t.belongs_to :character, foreign_key: true
      t.belongs_to :modifier, foreign_key: true

      t.timestamps
    end
  end
end
