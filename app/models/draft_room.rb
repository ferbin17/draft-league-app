class DraftRoom < ApplicationRecord
  validates_presence_of :name
  has_one :draft_current_slot
  has_many :draft_room_players, -> {where(is_brought: false)}
  has_many :players, through: :draft_room_players
  belongs_to :user
  after_create :populate_player_data
  
  private
    def populate_player_data
      DraftRoomPlayersCreatorJob.perform_now(self.id)
    end
end
