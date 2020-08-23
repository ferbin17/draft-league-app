class DraftRoomPlayerChangerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    draft_room = DraftRoom.find_by_id(args[0])
    if draft_room.present?
      players = draft_room.players.group_by(&:id)
      if players.present?
        rand = players.keys.sample
        player = players.delete(rand).first
        # player.update(round: player.round.to_i + 1)
        current_slot = draft_room.draft_current_slot
        current_slot.update(player_id: player.id, last_time_set: Time.now)
      end
    end
  end
end
