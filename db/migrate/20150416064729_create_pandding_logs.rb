class CreatePanddingLogs < ActiveRecord::Migration
  def change
    create_table :pandding_logs do |t|
      t.references :order, index: true
      t.references :user, index: true
      t.string :reason

      t.timestamps
    end
  end
end
