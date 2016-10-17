class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :str, null: false
      t.integer :dex, null: false
      t.integer :con, null: false
      t.integer :int, null: false
      t.integer :wis, null: false
      t.integer :cha, null: false

      t.timestamps
    end
  end
end
