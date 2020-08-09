class CreateMatchStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :match_statistics do |t|
      t.integer :league_id
      t.integer :team_id
      t.string :category
      t.integer :home
      t.integer :away
      t.integer :total
      t.timestamps
    end
  end
end
