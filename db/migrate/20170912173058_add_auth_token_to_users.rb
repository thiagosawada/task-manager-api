class AddAuthTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auth_token, :string
    # Serve para acelerar na hora de fazer pesquisas
    add_index :users, :auth_token, unique: true
  end
end
