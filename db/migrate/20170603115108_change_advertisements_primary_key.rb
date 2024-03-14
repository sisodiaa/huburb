class ChangeAdvertisementsPrimaryKey < ActiveRecord::Migration[5.0]
  def change
    add_column :advertisements, :uuid, :uuid, default: "uuid_generate_v4()"

    change_table :advertisements do |t|
      t.remove :id
      t.rename :uuid, :id
    end

    execute "ALTER TABLE advertisements ADD PRIMARY KEY (id);"
  end
end
