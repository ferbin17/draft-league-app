module DraftRoomsHelper
  def check_draft_starter(dr)
    dr.date == Date.today && dr.time.localtime.strftime("%H%M") <= Time.now.localtime.strftime("%H%M")
  end
  
  def is_owner(user, dr)
    dr.user_id == user.id
  end
  
  def timer_handler(dcs)
    time = dcs.last_time_set.localtime + DraftCurrentSlot::TIME_INTERVAL[dcs.draft_state.to_s].minutes
    return format_time_for_timer(time, time)
  end
  
  def format_time_for_timer(date, time)
    "#{date.strftime("%m/%e/%Y")} #{time.localtime.strftime("%k:%M:%S")}"
  end
    
  def date_diff(dr)
    df = (dr.date - Date.today).to_i.to_s
    df = (df.length == 1 ? "0#{df}" : df)
    df
  end
end
