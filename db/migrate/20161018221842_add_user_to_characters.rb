class AddUserToCharacters < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :user_name, :string
  end
end
