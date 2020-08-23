class DraftRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "draft_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
