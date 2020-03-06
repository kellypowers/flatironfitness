class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.string :category 
      t.string :description
      t.integer :time
      t.string :time_units
      t.datetime :start_date
      t.datetime :end_date
      t.integer :user_id
    end
  end
end
