class CreateDraftCurrentSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :draft_current_slots do |t|
      t.integer :draft_state, default: 0
      t.integer :draft_room_id
      t.datetime :last_time_set
      t.integer :player_id
      t.integer :user_id
      t.timestamps
    end
  end
end
