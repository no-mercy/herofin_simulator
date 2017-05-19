class CreateHrProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :hr_profiles do |t|
      t.integer :user_id
      t.datetime :enroll_date
      t.datetime :fire_date
      t.string :state

      t.timestamps
    end
  end
end
