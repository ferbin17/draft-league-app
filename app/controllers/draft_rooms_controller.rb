class DraftRoomsController < ApplicationController
  
  def index
    @draft_rooms = @current_user.draft_rooms
  end
  
  def new
    @draft_room = DraftRoom.new
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
  end
  
  def destroy
  end
  
  def start_auction
    @draft_room = DraftRoom.find_by_id(params[:id])
    @current_slot = DraftCurrentSlot.find_or_create_by(draft_room_id: @draft_room)
  end

  private
  
    def draft_room_params
      params.require(:draft_room).permit(:name, :date, :time)
    end
end
