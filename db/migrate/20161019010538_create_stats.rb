class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.belongs_to :character, foreign_key: true
      t.string :name
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
