class DraftRoomStateChangerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    draft_room = DraftRoom.find_by_id(args[0])
    if draft_room.present?
      current_slot = draft_room.draft_current_slot
      current_slot.update(draft_state: args[1], last_time_set: Time.now)
    end
  end
end
