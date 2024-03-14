class CreateInvitees < ActiveRecord::Migration[5.0]
  def change
    create_table :invitees do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :city
      t.text :description

      t.timestamps
    end
  end
end
