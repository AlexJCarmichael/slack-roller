class CreateActors < ActiveRecord::Migration[5.0]
  def change
    create_table :actors do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
