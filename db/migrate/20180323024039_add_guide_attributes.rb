class AddGuideAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :type, :string
    add_column :users, :birthdate, :datetime
    add_column :users, :main_phone, :string
    add_column :users, :secondary_phone, :string
    add_column :users, :bio, :text
  end
end
