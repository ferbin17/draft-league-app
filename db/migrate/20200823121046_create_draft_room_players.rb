class CreateDraftRoomPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :draft_room_players do |t|
      t.integer :draft_room_id
      t.integer :player_id
      t.integer :round_completed, default: 0
      t.boolean :is_brought, default: false
      t.timestamps
    end
  end
end
