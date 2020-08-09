class CreateCompetetions < ActiveRecord::Migration[6.0]
  def change
    create_table :competetions do |t|
      t.integer :league_id
      t.string :name
      t.integer :type_id
      t.integer :country_id
      t.timestamps
    end
  end
end
