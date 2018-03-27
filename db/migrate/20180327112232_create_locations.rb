class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.decimal :lat, null: false, precision: 15, scale: 10
      t.decimal :lng, null: false, precision: 15, scale: 10
      t.belongs_to :guide, null: false

      t.timestamps
    end
  end
end
