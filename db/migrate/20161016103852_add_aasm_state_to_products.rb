class AddAasmStateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :aasm_state, :string, default: "published"
  end
end
