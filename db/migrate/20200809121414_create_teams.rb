class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.integer :team_id
      t.string :name
      t.string :code
      t.string :logo
      t.integer :country_id
      t.integer :league_id
      t.boolean :is_national, default: false
      t.string :founded
      t.timestamps
    end
  end
end
