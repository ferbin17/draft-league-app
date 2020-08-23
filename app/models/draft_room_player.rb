class DraftRoomPlayer < ApplicationRecord
  belongs_to :draft_room
  belongs_to :player
end
