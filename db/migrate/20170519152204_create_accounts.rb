class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :available_money
      t.integer :user_id
      t.string :state

      t.timestamps
    end
  end
end
