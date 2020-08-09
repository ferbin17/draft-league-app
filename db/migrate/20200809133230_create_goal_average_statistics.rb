class CreateGoalAverageStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :goal_average_statistics do |t|
      t.integer :league_id
      t.integer :team_id
      t.string :category
      t.decimal :home
      t.decimal :away
      t.decimal :total
      t.timestamps
    end
  end
end
