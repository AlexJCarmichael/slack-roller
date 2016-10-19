class AddActorRefToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_reference :characters, :actor, foreign_key: true
  end
end
