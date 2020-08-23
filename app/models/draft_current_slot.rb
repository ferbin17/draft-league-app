class DraftCurrentSlot < ApplicationRecord
  belongs_to :draft_room
  belongs_to :player, optional: true
  LEVELS = {"0" => "Timer set for Start", "1" => "First Player",
            "2" => "Normal Time for Bidding", "3" => "Extra Time for Bidding",
            "4" => "Next Player", "5" => "Auction Paused"}
  TIME_INTERVAL = {"0" => 5, "1" => 1, "2" => 2, "3" => 0.25, "4" => 0.5, "5" => ""}
  
  def draft_state_level
    LEVEL[draft_state.to_s]
  end
end
