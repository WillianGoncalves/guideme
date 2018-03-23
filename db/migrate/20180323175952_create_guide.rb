class CreateGuide < ActiveRecord::Migration[5.1]
  def change
    create_table :guides do |t|
      t.datetime :birthdate
      t.string :main_phone
      t.string :secondary_phone
      t.text :bio
      t.boolean :approved
      t.references :users
    end

    remove_column :users, :type
    remove_column :users, :birthdate
    remove_column :users, :main_phone
    remove_column :users, :secondary_phone
    remove_column :users, :bio
  end
end
