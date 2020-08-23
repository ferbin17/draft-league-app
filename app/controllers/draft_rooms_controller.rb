class DraftRoomsController < ApplicationController
  
  def index
    @draft_rooms = DraftRoom.all
    # @draft_rooms = @current_user.draft_rooms
  end
  
  def new
    @draft_room = @current_user.draft_rooms.new
  end
  
  def create
    @draft_room = @current_user.draft_rooms.new(draft_room_params)
    if @draft_room.save
      redirect_to @draft_room
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def show
    @draft_room = DraftRoom.find_by_id(params[:id])
    @current_slot = @draft_room.draft_current_slot
  end
  
  def destroy
  end
  
  def start_auction
    @draft_room = DraftRoom.find_by_id(params[:id])
    unless @draft_room.draft_current_slot.present?
      @current_slot = @draft_room.build_draft_current_slot(draft_state: 0,
        last_time_set: Time.now.localtime)
      if @draft_room.save
        DraftRoomStateChangerJob.set(wait: 5.minutes).perform_later(@draft_room.id, 1)
      end
    end
    redirect_to action: :auction_room, id: @draft_room.id
  end
  
  def auction_room
    @draft_room = DraftRoom.find_by_id(params[:id])
    @current_slot = @draft_room.draft_current_slot
    if @current_slot.present?
      if @current_slot.draft_state == 0
        ActionCable.server.broadcast 'draft_room_channel', content: "OK"
        # prevent happening twice
        DraftRoomPlayerChangerJob.perform_now(@draft_room.id) unless @current_slot.player.present?
      elsif @current_slot.draft_state == 1 && @current_slot.player.present?
        # prevent happening twice
        DraftRoomStateChangerJob.set(wait: 30.seconds).perform_later(@draft_room.id, 2)
      elsif @current_slot.draft_state == 2
        @players = @draft_room.players.limit(10)
        @player = @current_slot.player
      end
    end
  end

  private
  
    def draft_room_params
      params.require(:draft_room).permit(:name, :date, :time)
    end
end
