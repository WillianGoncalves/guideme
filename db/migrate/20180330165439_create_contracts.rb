class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.float :price
      t.text :goals, null: false
      t.references :guide, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
