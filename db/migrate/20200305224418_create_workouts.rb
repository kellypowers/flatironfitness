class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string :category
      t.integer :time
      t.string :time_units
      t.string :comment
      t.datetime :date
      t.integer :user_id
    end
  end
end
