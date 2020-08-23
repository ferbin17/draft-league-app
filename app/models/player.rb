class Player < ApplicationRecord
  has_many :draft_current_slots
  has_many :draft_room_players
  has_many :draft_rooms, through: :draft_room_players
end
