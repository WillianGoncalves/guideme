class AddStatusToGuides < ActiveRecord::Migration[5.1]
  def change
    add_column :guides, :status, :integer, default: 0
    remove_column :guides, :approved
  end
end
