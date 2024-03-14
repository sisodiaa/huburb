class AddUserRefToPages < ActiveRecord::Migration[5.0]
  def change
    add_reference :pages, :owner, references: :users
    add_foreign_key :pages, :users, column: :owner_id
  end
end
