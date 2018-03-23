class CreateGuide < ActiveRecord::Migration[5.1]
  def change
    create_table :guides do |t|
      t.datetime :birthdate, null: false
      t.string :main_phone, null: false
      t.string :secondary_phone
      t.text :bio, null: false
      t.integer :status, default: 0
      t.references :user, foreign_key: true
    end
  end
end
