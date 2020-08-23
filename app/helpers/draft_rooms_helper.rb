module DraftRoomsHelper
  def check_draft_starter(dr)
    dr.date == Date.today && dr.time.localtime <= Time.now.localtime
  end
  
  def is_owner(user, dr)
    dr.user_id == user.id
  end
end
