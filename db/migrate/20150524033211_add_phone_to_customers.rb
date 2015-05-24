class AddPhoneToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :phone, :string
    add_column :customers, :consignee, :string
  end
end
