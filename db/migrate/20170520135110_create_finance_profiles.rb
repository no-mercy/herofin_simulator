class CreateFinanceProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :finance_profiles do |t|
      t.integer :user_id
      t.datetime :enroll_date
      t.datetime :last_paid_time

      t.timestamps
    end
  end
end
