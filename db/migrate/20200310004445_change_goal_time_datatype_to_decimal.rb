class ChangeGoalTimeDatatypeToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :goals, :time, :real
  end
end
