class CreateOperations < ActiveRecord::Migration[5.1]
  def change
    create_table :operations do |t|
      t.string :name
      t.integer :amount
      t.string :operation_type
      t.integer :source_acc_id
      t.integer :recipient_acc_id
      t.string :state

      t.timestamps
    end
  end
end
