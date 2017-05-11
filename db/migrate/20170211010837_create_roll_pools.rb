class CreateRollPools < ActiveRecord::Migration[5.0]
  def change
    create_table :roll_pools do |t|
      t.string :pool
      t.belongs_to :actor, foreign_key: true

      t.timestamps
    end
  end
end
