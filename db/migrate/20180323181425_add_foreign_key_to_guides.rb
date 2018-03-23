class AddForeignKeyToGuides < ActiveRecord::Migration[5.1]
  def change
    rename_column :guides, :users_id, :user_id
    add_foreign_key :guides, :users
  end
end
