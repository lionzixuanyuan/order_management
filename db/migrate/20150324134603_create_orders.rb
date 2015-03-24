class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :code
      t.integer :customer_id
      t.integer :totle_amount
      t.decimal :totle_sum
      t.string :inceptor
      t.string :saleman
      t.integer :creator_id
      t.string :state

      t.timestamps
    end
  end
end
