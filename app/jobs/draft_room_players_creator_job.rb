class DraftRoomPlayersCreatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    draft_room = DraftRoom.find_by_id(args[0])
    if draft_room.present?
      players = Player.all.group_by(&:id)
      while players.present?
        rand = players.keys.sample
        player = players.delete(rand).first
        draft_room.draft_room_players.build(player: player)
      end
      draft_room.save
    end
  end
end
