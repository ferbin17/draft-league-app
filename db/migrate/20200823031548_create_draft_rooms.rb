class CreateDraftRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :draft_rooms do |t|
      t.string :name
      t.date :date
      t.time :time
      t.integer :user_id
      t.boolean :is_deleted, default: false
      t.boolean :draft_completed, default: false
      t.timestamps
    end
  end
end
