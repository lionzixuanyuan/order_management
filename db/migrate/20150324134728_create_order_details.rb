class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :amount, default: 1
      t.decimal :discount, default: 100
      t.decimal :sum

      t.timestamps
    end
  end
end
