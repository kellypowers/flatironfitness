class ChangeWorkoutTimeDatatypeToReal < ActiveRecord::Migration[5.2]
  def change
    change_column :workouts, :time, :real
  end
end
