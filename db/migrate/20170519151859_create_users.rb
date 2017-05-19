class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :birthday
      t.datetime :time_of_death
      t.string :state

      t.timestamps
    end
  end
end
