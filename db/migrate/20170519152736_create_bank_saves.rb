class CreateBankSaves < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_saves do |t|
      t.integer :available_money

      t.timestamps
    end
  end
end
