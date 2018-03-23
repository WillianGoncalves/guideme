class ChangeDefaultAndNullOnGuides < ActiveRecord::Migration[5.1]
  def change
    change_column_default :guides, :approved, false
    change_column_null :guides, :birthdate, false
    change_column_null :guides, :main_phone, false
    change_column_null :guides, :bio, false
  end
end
