class RemoveCharacterFromModifiers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :modifiers, :character, foreign_key: true
  end
end
