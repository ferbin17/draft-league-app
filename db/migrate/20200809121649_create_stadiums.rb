class CreateStadiums < ActiveRecord::Migration[6.0]
  def change
    create_table :stadiums do |t|
      t.integer :team_id
      t.string :name
      t.string :surface
      t.string :address
      t.string :city
      t.string :capacity
      t.timestamps
    end
  end
end
