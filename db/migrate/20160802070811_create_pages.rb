class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :name
      t.text :description
      t.integer :category, default: 0

      t.timestamps
    end
  end
end
