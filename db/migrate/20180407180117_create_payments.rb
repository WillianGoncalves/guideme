class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.float :comission, null: false, default: 0
      t.integer :payment_type, null: false, default: 0
      t.belongs_to :contract, null: false

      t.timestamps
    end
  end
end
