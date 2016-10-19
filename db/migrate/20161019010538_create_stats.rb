class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :attribute

      t.timestamps
    end
  end
end
