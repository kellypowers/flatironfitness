class ChangeWorkoutTimeDatatypeToDecimal < ActiveRecord::Migration[5.2]
  def change
    # change_column(table_name, column_name, type)
    change_column :workouts, :date, :real
  end
end
