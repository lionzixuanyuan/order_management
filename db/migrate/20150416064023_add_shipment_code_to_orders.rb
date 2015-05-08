class AddShipmentCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipment_code, :string
  end
end
