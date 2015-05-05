class AddPassTimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pass_time, :datetime
  end
end
