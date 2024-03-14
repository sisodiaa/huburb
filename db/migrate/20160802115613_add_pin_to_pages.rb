class AddPinToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :pin, :string
    add_index :pages, :pin, unique: true
  end
end
