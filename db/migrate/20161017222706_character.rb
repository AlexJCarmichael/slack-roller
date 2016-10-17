class Character < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :char_name, null: false

      t.timestamps
    end
  end
end
