class ChangeWorkoutDateDatatypeBackToDatetime < ActiveRecord::Migration[5.2]
  def change
    change_column :workouts, :date, :datetime
  end
end
